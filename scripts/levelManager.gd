extends Node2D

var health: int = 5
var coins: int = 250
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

func deductHealth() -> void:
	health -= 1
	if (health < 1):
		print("You DIED")
	ui.setHealth(health)

func addCoins(amount: int) -> void:
	coins += amount
	ui.setCoins(coins)
