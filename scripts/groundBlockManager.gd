extends Area2D

@export_enum("grass", "sand", "snow") var type: String = "grass"
@onready var sprite = $Sprite2D

func _ready() -> void:
	if (type != "grass"):
		sprite.texture = load("res://assets/Landscape tiles/" + type + ".png")
