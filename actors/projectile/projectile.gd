extends Area2D

var velocity: Vector2 = Vector2(0,0)
var stun: bool = false
var sin_value: int = 0
var time = 0
var t = 0.5 # influences moving towards target
var p = 0.1 # influences oscillating

func fire(forward: Vector2, speed: float, type: bool): #true = normal, false = stun
	velocity = forward * speed
	look_at(position + forward)
	stun = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if (stun):
		position += velocity * delta
	else:
		time += delta
		var perpendicular = Vector2(position.y, -position.x)
		position += ((p * perpendicular * sin(time)) * velocity/80 * delta)


func _on_time_to_live_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	(body as Enemy).hit(1)
	queue_free()
