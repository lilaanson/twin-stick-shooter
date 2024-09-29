extends Area2D

var velocity: Vector2 = Vector2(0,0)
var stun: bool = false
var sin_value: int = 0
var time = 0
var t = 0.5 # influences moving towards target
var p = 0.1 # influences oscillating
var forward

func fire(speed: float): #true = normal, false = stun
	forward = Vector2(1,0)
	velocity = forward * speed
	look_at(position + forward)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta



func _on_body_entered(body: Node2D) -> void:
	pass
	# reduce health


func _on_timer_timeout() -> void:
	queue_free()
