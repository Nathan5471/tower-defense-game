extends Node2D

var coins = 250
var selectedTower: Area2D = null
var upgradeCost: int = 0
var upgradeAvailable: bool = false
var sellValue: int = 0
@onready var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]
@onready var coinAmountLabel = $CoinAmount
@onready var openShopButton = $OpenShop
@onready var shop = $Shop
@onready var buyArcherButton = $Shop/BuyArcher
@onready var buyWizardButton = $Shop/BuyWizard
@onready var upgradeMenu = $UpgradeMenu
@onready var upgradeSprite = $UpgradeMenu/CurrentSprite
@onready var upgradeInfo = $UpgradeMenu/UpgradeInfo
@onready var buyUpgradeButton = $UpgradeMenu/BuyUpgrade
@onready var sellTowerButton = $UpgradeMenu/SellTower

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
	if (upgradeAvailable):
		if (coins < upgradeCost):
			buyUpgradeButton.disabled = true
		else:
			buyUpgradeButton.disabled = false

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

func _on_close_menu_pressed() -> void:
	upgradeMenu.visible = false
	openShopButton.visible = true

func openUpgradeMenu(tower: Area2D, currentSprite: CompressedTexture2D, newUpgradeSprite: Texture2D, towerName: String, towerLevel: int, currentStats: String, upgradeText: String, newUpgradeCost: int, newSellValue: int):
	selectedTower = tower
	upgradeCost = newUpgradeCost
	openShopButton.visible = false
	shop.visible = false
	upgradeMenu.visible = true
	upgradeSprite.texture = currentSprite
	upgradeInfo.text = "%s Tower (%d)
	%s" % [towerName, towerLevel, currentStats]
	if (towerLevel < 3):
		upgradeAvailable = true
		buyUpgradeButton.text = "Buy Upgrade
		%s
		$%d" % [upgradeText, upgradeCost]
		buyUpgradeButton.icon = newUpgradeSprite
		if (coins > upgradeCost):
			buyUpgradeButton.disabled = false
		else:
			buyUpgradeButton.disabled = true
	else:
		upgradeAvailable = false
		buyUpgradeButton.text = "MAX LEVEL ACHIEVED!"
		buyUpgradeButton.icon = null
		buyUpgradeButton.disabled = true
	sellValue = newSellValue
	sellTowerButton.text = "Sell Tower
	$" + str(sellValue)
