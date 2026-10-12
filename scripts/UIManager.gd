extends Node2D

var coins = 250
var selectedTower: Area2D = null
var upgradeCost: int = 0
var upgradeAvailable: bool = false
var sellValue: int = 0
@onready var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]
@onready var coinAmountLabel = $CoinAmount
@onready var waveLabel = $Wave
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

func setWave(wave: int) -> void:
	waveLabel.text = "Wave: %d/13" % wave

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
	selectedTower.hideDetectionOverlay()
	selectedTower = null
	openShopButton.visible = true

func openUpgradeMenu(tower: Area2D, currentSprite: CompressedTexture2D, newUpgradeSprite: Texture2D, towerName: String, towerLevel: int, currentStats: String, upgradeText: String, newUpgradeCost: int, newSellValue: int):
	if selectedTower:
		selectedTower.hideDetectionOverlay()
	selectedTower = tower
	selectedTower.showDetectionOverlay()
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

func _on_buy_upgrade_pressed() -> void:
	if not selectedTower || not upgradeCost:
		return
	var levelManager = get_parent()
	var newCoins = levelManager.handleUpgradeTower(upgradeCost)
	if (newCoins == -1):
		return
	setCoins(newCoins)
	selectedTower.handleUpgrade()

func _on_sell_tower_pressed() -> void:
	if not selectedTower || not sellValue:
		return
	var towerBlock = selectedTower.get_parent()
	towerBlock.tower = null
	towerBlock.canPlace = true
	selectedTower.queue_free()
	var levelManager = get_parent()
	levelManager.addCoins(sellValue)
	upgradeMenu.visible = false
	selectedTower = null
	openShopButton.visible = true
