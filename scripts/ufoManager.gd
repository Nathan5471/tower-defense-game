extends PathFollow2D

@export_range(0, 3) var level: int = 0
@export var health: int = 10
@export var speed: int = 125
@onready var sprite = $Area2D/Sprite2D

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/UFO/UFO-" + str(level) + ".png")

func _process(delta: float) -> void:
	progress += speed * delta
	if (progress_ratio >= 1.0):
		queue_free()
