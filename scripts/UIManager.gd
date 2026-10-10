extends Node2D

var coins = 250
@onready var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]
@onready var coinAmountLabel = $CoinAmount

func setHealth(health: int) -> void:
	for i in range(1, 6):
		if (i > health):
			hearts[i-1].visible = false
		else:
			hearts[i-1].visible = true

func setCoins(newCoins: int) -> void:
	coins = newCoins
	coinAmountLabel.text = str(coins)
