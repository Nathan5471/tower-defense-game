extends Node2D

var coins = 250
@onready var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]
@onready var coinAmountLabel = $CoinAmount
@onready var openShopButton = $OpenShop
@onready var shop = $Shop
@onready var buyArcherButton = $Shop/BuyArcher
@onready var buyWizardButton = $Shop/BuyWizard

func setHealth(health: int) -> void:
	for i in range(1, 6):
		if (i > health):
			hearts[i-1].visible = false
		else:
			hearts[i-1].visible = true

func setCoins(newCoins: int) -> void:
	coins = newCoins
	coinAmountLabel.text = str(coins)

func _on_open_shop_pressed() -> void:
	openShopButton.visible = false
	shop.visible = true
	if (coins < 200):
		buyArcherButton.disabled = true
	else:
		buyArcherButton.disabled = false
	if (coins < 500):
		buyWizardButton.disabled = true
	else:
		buyWizardButton.disabled = false

func _on_close_shop_pressed() -> void:
	shop.visible = false
	openShopButton.visible = true
