extends Area2D

@export_range(0, 2) var level: int = 0
@onready var sprite = $Sprite2D

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/Towers/Wizard/wizard_level_" + str(level) + ".png")
