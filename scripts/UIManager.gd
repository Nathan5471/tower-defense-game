extends Node2D

var coins = 650
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
	if (coins < 200):
		buyArcherButton.disabled = true
	else:
		buyArcherButton.disabled = false
	if (coins < 550):
		buyWizardButton.disabled = true
	else:
		buyWizardButton.disabled = false

func _on_open_shop_pressed() -> void:
	openShopButton.visible = false
	shop.visible = true
	if (coins < 200):
		buyArcherButton.disabled = true
	else:
		buyArcherButton.disabled = false
	if (coins < 550):
		buyWizardButton.disabled = true
	else:
		buyWizardButton.disabled = false

func _on_close_shop_pressed() -> void:
	shop.visible = false
	openShopButton.visible = true

func handleMakePurchase(type: String) -> void:
	var levelManager = get_parent()
	var newCoins = levelManager.handlePurchase(type, 200 if (type == "archer") else 500)
	if (newCoins != -1):
		coins = newCoins
		coinAmountLabel.text = str(coins)
		buyArcherButton.disabled = true
		buyWizardButton.disabled = true

func finishPurchase() -> void:
	if (coins < 200):
		buyArcherButton.disabled = true
	else:
		buyArcherButton.disabled = false
	if (coins < 550):
		buyWizardButton.disabled = true
	else:
		buyWizardButton.disabled = false

func _on_buy_archer_pressed() -> void:
	handleMakePurchase("archer")

func _on_buy_wizard_pressed() -> void:
	handleMakePurchase("wizard")
