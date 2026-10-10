extends PathFollow2D

@export_range(0, 3) var level: int = 0
@export var health: int = 10
@export var speed: int = 125
@onready var sprite = $Area2D/Sprite2D
@onready var levelManager: Node2D = get_parent().get_parent() as Node2D

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/UFO/UFO-" + str(level) + ".png")

func _process(delta: float) -> void:
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
