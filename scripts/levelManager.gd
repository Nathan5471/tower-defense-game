extends Node2D

const waves = [{"tier1": 15, "tier2": 0, "tier3": 0},{"tier1": 20, "tier2": 5, "tier3": 0},{"tier1": 20, "tier2": 15, "tier3": 0},{"tier1": 25, "tier2": 10, "tier3": 10},{"tier1": 35, "tier2": 20, "tier3": 15},{"tier1": 40, "tier2": 30, "tier3": 30},{"tier1": 50, "tier2": 35, "tier3": 35},{"tier1": 50, "tier2": 50, "tier3": 50},{"tier1": 0, "tier2": 100, "tier3": 75},{"tier1": 0, "tier2": 75, "tier3": 125},{"tier1": 0, "tier2": 75, "tier3": 175},{"tier1": 0, "tier2": 100, "tier3": 250},{"tier1": 0, "tier2": 0, "tier3": 1000}]
const baseUFOStats = [{"health": 10, "speed": 125},{"health": 25, "speed": 250},{"health": 60, "speed": 450}]

var health: int = 5
var coins: int = 250
var currentWave = 1
var currentPurchase: String = "none"
var currentSpawn: int = 1
var finalSpawn: bool = false
@export var ufoScene: PackedScene 
@onready var path = $UFOPath
@onready var timer = $Timer
@onready var ui = $UI

func handleStartWave() -> void:
	finalSpawn = false
	var waveData = waves[currentWave-1]
	var totalEnemies = waveData.tier1 + waveData.tier2 + waveData.tier3
	timer.wait_time = 20.0 / totalEnemies
	currentSpawn = 1
	timer.start()

func _ready() -> void:
	handleStartWave()

func spawnUFO() -> void:
	if not ufoScene or not path:
		return
	var newUFO = ufoScene.instantiate()
	var waveData = waves[currentWave-1]
	if (waveData.tier1 + waveData.tier2 < currentSpawn):
		newUFO.setLevel(2, baseUFOStats[2].health, baseUFOStats[2].speed)
	elif (waveData.tier1 < currentSpawn):
		newUFO.setLevel(1, baseUFOStats[1].health, baseUFOStats[1].speed)
	path.add_child(newUFO)
	currentSpawn += 1
	if (waveData.tier1 + waveData.tier2 + waveData.tier3 < currentSpawn):
		timer.stop()
		finalSpawn = true
		timer.wait_time = 3
		timer.start()

func _on_timer_timeout() -> void:
	if not finalSpawn:
		spawnUFO()
	else:
		timer.stop()
		currentWave += 1
		handleStartWave()

func deductHealth() -> void:
	health -= 1
	if (health < 1):
		print("You DIED")
	ui.setHealth(health)

func addCoins(amount: int) -> void:
	coins += amount
	ui.setCoins(coins)

func handlePurchase(type: String, cost: int) -> int:
	if (cost > coins || currentPurchase != "none"):
		return -1
	currentPurchase = type
	coins -= cost
	return coins

func finishPurchase() -> void:
	currentPurchase = "none"
	ui.finishPurchase()

func handleOpenUpgradeMenu(tower: Area2D, currentSprite: CompressedTexture2D, upgradeSprite: CompressedTexture2D, towerName: String, towerLevel: int, currentStats: String, upgradeText: String, newUpgradeCost: int, newSellValue: int):
	ui.openUpgradeMenu(tower, currentSprite, upgradeSprite, towerName, towerLevel, currentStats, upgradeText, newUpgradeCost, newSellValue)

func handleUpgradeTower(cost: int) -> int:
	if (cost > coins):
		return -1
	coins -= cost
	return coins
