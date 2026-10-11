extends Area2D

@export_range(0, 2) var level: int = 0
@onready var sprite = $Sprite2D
@onready var detectionOverlay = $DetectionArea/DetectionOverlay

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/Towers/Archer/archer_level_" + str(level) + ".png")

func hideDetectionOverlay() -> void:
	detectionOverlay.visible = false

func showDetectionOverlay() -> void:
	detectionOverlay.visible = true
