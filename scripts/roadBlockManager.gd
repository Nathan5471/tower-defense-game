extends Area2D

@export_enum("spring", "desert", "winter") var type: String = "spring"
@export_range(1,11) var direction: int = 1
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = load("res://assets/Road tiles/" + type.capitalize() + " biome/road_" + type + "(" + str(direction) + ").png")
