extends Area2D

@export_range(0, 2) var level: int = 0
@export var projectileSpeed: int = 600
@export var projectileDamage: int = 5
@export var projectileScene: PackedScene
var disabled: bool = false
@onready var sprite = $Sprite2D
@onready var detectionOverlay = $DetectionArea/DetectionOverlay
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
	if (detectedEnemies.size() > 0 && timeSinceLastShot > 1.0):
		timeSinceLastShot = 0.0
		var target = detectedEnemies[0]
		fireAtEnemy(target)

func fireAtEnemy(target: PathFollow2D):
	var projectile = projectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.startProjectile(target, projectileSpeed, projectileDamage)
