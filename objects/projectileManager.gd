extends Area2D

var target: PathFollow2D = null
var speed: float = 0.0
var direction: Vector2 = Vector2.ZERO

func startProjectile(newTarget: PathFollow2D, newSpeed: float) -> void:
	target = newTarget
	speed = newSpeed
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()

func _process(delta: float) -> void:
	if target:
		global_position += direction * speed * delta
