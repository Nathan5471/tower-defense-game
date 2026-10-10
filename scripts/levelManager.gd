extends Node2D

@export var ufoScene: PackedScene 
@onready var path = $UFOPath
@onready var timer = $Timer
@onready var ui = $UI

func spawnUFO() -> void:
	if not ufoScene or not path:
		return
	var newUFO = ufoScene.instantiate()
	path.add_child(newUFO)

func _on_timer_timeout() -> void:
	spawnUFO()
