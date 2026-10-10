@tool
extends Area2D

@export_enum("spring", "desert", "winter") var type: String = "spring":
	set(value):
		type = value
		updateRoadSprite()
@export_range(1,11) var direction: int = 1:
	set(value):
		direction = value
		updateRoadSprite()
@onready var sprite = $Sprite2D

func _ready() -> void:
	updateRoadSprite()

func updateRoadSprite() -> void:
	if not is_node_ready():
		return
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.texture = load("res://assets/Road tiles/" + type.capitalize() + " biome/road_" + type + "(" + str(direction) + ").png")
