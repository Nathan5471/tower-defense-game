extends Node2D

var mainScene: String = "res://main.tscn"
var winStatus: bool = true
var textSet: bool = false
@onready var label = $Label

func setWinStatus(status: bool) -> void:
	winStatus = status

func _process(delta: float) -> void:
	if not textSet && label:
		label.text = "Congrats on winning!!!" if (winStatus) else "Sorry, you lost!"
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(mainScene)
