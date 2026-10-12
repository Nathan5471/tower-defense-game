extends PathFollow2D

var level: int = 0
var health: int = 10
var speed: int = 125
var spriteNeedsUpdating = false
@onready var sprite = $Area2D/Sprite2D
@onready var levelManager: Node2D = get_parent().get_parent() as Node2D

func setLevel(newLevel: int, newHealth: int, newSpeed: int) -> void:
	level = newLevel
	health = newHealth
	speed = newSpeed
	if (level != 0):
		if not sprite:
			spriteNeedsUpdating = true
			return
		sprite.texture = load("res://assets/UFO/UFO-%d.png" % level)

func _process(delta: float) -> void:
	if spriteNeedsUpdating && sprite:
		sprite.texture = load("res://assets/UFO/UFO-%d.png" % level)
	progress += speed * delta
	if (progress_ratio >= 1.0):
		handleReachEnd()

func handleTakeDamage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		handleDeath()

func handleDeath() -> void:
	if levelManager && levelManager.has_method("addCoins"):
		levelManager.addCoins(50)
	queue_free()

func handleReachEnd() -> void:
	if levelManager && levelManager.has_method("deductHealth"):
		levelManager.deductHealth()
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "ArrowProjectile" || area.name == "WizardProjectile":
		handleTakeDamage(area.damage)
		area.queue_free()
