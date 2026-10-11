extends Area2D

@export_range(0, 2) var level: int = 0
var disabled: bool = false
@onready var sprite = $Sprite2D
@onready var detectionOverlay = $DetectionArea/DetectionOverlay

func _ready() -> void:
	if (level != 0):
		sprite.texture = load("res://assets/Towers/Wizard/wizard_level_" + str(level) + ".png")

func hideDetectionOverlay() -> void:
	if detectionOverlay:
		detectionOverlay.visible = false

func showDetectionOverlay() -> void:
	if detectionOverlay:
		detectionOverlay.visible = true

func disable() -> void:
	disabled = true
