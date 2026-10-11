@tool
extends Area2D

@export_enum("grass", "sand", "snow") var type: String = "grass":
	set(value):
		type = value
		updateGroundSprite()
@export var canPlace: bool = true
@export var archerTowerScene: PackedScene
@export var wizardTowerScene: PackedScene
var tower: Area2D = null
@onready var sprite = $Sprite2D

func _ready() -> void:
	if (type != "grass"):
		sprite.texture = load("res://assets/Landscape tiles/" + type + ".png")

func updateGroundSprite() -> void:
	if not is_node_ready():
		return
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.texture = load("res://assets/Landscape tiles/" + type + ".png")

func _on_mouse_entered() -> void:
	var levelManager = get_parent().get_parent()
	if (levelManager.currentPurchase != "none" && tower == null && canPlace == true):
		if (levelManager.currentPurchase == "archer"):
			tower = archerTowerScene.instantiate()
			add_child(tower)
			tower.position = Vector2(0, -80)
			tower.disable()
			tower.showDetectionOverlay()
		else:
			tower = wizardTowerScene.instantiate()
			add_child(tower)
			tower.position = Vector2(0, -60)
			tower.disable()
			tower.showDetectionOverlay()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (tower && canPlace && event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		canPlace = false
		tower.enable()
		tower.hideDetectionOverlay()
		var levelManager = get_parent().get_parent()
		levelManager.finishPurchase()

func _on_mouse_exited() -> void:
	if (tower && tower.disabled == true):
		tower.queue_free()
