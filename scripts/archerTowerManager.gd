extends Area2D

const upgradeLevels = [{"fireRate": 1, "damage": 5, "cost": 200}, {"fireRate": 2, "damage": 15, "cost": 450}, {"fireRate": 2, "damage": 35, "cost": 700}]
const sellValues: Array[int] = [100, 300, 700]

@export_range(0, 2) var level: int = 0
@export var projectileSpeed: int = 850
@export var projectileScene: PackedScene
var projectileDamage: int = 5
var fireRate = 1
var currentLevel: int = 1
var disabled: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var detectionOverlay: Sprite2D = $DetectionArea/DetectionOverlay
var detectedEnemies: Array[PathFollow2D] = []
var timeSinceLastShot: float = 100 # I chose a random number so it can fire when you place it 

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/Towers/Archer/archer_level_" + str(level) + ".png")

func hideDetectionOverlay() -> void:
	if detectionOverlay:
		detectionOverlay.visible = false

func showDetectionOverlay() -> void:
	if detectionOverlay:
		detectionOverlay.visible = true

func disable() -> void:
	disabled = true

func enable() -> void:
	disabled = false

func _on_detection_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent is PathFollow2D && !detectedEnemies.has(parent)):
		detectedEnemies.append(parent)

func _on_detection_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent is PathFollow2D && detectedEnemies.has(parent)):
		detectedEnemies.erase(parent)

func _process(delta: float) -> void:
	if disabled:
		return
	detectedEnemies = detectedEnemies.filter(func(enemy): return is_instance_valid(enemy))
	timeSinceLastShot += delta
	if (detectedEnemies.size() > 0 && timeSinceLastShot > 1.0 / fireRate):
		timeSinceLastShot = 0.0
		var target = detectedEnemies[0]
		fireAtEnemy(target)

func fireAtEnemy(target: PathFollow2D):
	var projectile = projectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.startProjectile(target, projectileSpeed, projectileDamage)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		var levelManager = get_parent().get_parent().get_parent()
		var upgradeStats
		if (currentLevel < 3):
			upgradeStats = upgradeLevels[currentLevel]
		else:
			upgradeStats = null
		var upgradeIcon
		if (currentLevel < 3):
			upgradeIcon = load("res://assets/Towers/Archer/archer_level_%d.png" % (currentLevel))
		else:
			upgradeIcon = null
		levelManager.handleOpenUpgradeMenu(self, sprite.texture, upgradeIcon, "Archer", currentLevel, "%s shot/s | %s damage" % [fireRate, projectileDamage], "" if upgradeStats == null else "%d damage
		%d shots per second" % [upgradeStats.fireRate, upgradeStats.damage], 0 if upgradeStats == null else upgradeStats.cost, sellValues[currentLevel-1])

func handleUpgrade() -> void:
	if currentLevel == 3:
		return
	currentLevel += 1
	sprite.texture = load("res://assets/Towers/Archer/archer_level_%d.png" % (currentLevel-1))
	projectileDamage = upgradeLevels[currentLevel-1].damage
	fireRate = upgradeLevels[currentLevel-1].fireRate
	var levelManager = get_parent().get_parent().get_parent()
	var upgradeStats
	if (currentLevel < 3):
		upgradeStats = upgradeLevels[currentLevel]
	else:
		upgradeStats = null
	var upgradeIcon
	if (currentLevel < 3):
		upgradeIcon = load("res://assets/Towers/Archer/archer_level_%d.png" % (currentLevel))
	else:
		upgradeIcon = null
	levelManager.handleOpenUpgradeMenu(self, sprite.texture, upgradeIcon, "Archer", currentLevel, "%s shot/s | %s damage" % [fireRate, projectileDamage], "" if upgradeStats == null else "%d damage
	%d shots per second" % [upgradeStats.fireRate, upgradeStats.damage], 0 if upgradeStats == null else upgradeStats.cost, sellValues[currentLevel-1])
