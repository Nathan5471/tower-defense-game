@tool
extends Area2D

@export_enum("grass", "sand", "snow") var type: String = "grass":
	set(value):
		type = value
		updateGroundSprite()
@export var canPlace: bool = true
@onready var sprite = $Sprite2D

func _ready() -> void:
	if (type != "grass"):
		sprite.texture = load("res://assets/Landscape tiles/" + type + ".png")

func updateGroundSprite() -> void:
	if not is_node_ready():
		return
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.texture = load("res://assets/Landscape tiles/" + type + ".png")
