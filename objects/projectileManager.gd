extends Area2D

var target: PathFollow2D = null
var speed: float = 0.0
var damage: int = 0
var direction: Vector2 = Vector2.ZERO

func startProjectile(newTarget: PathFollow2D, newSpeed: float, newDamage: int) -> void:
	target = newTarget
	speed = newSpeed
	damage = newDamage
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		if not is_instance_valid(target):
			queue_free()
		global_position += direction * speed * delta
