extends Area2D

var velocity: Vector2 = Vector2(0,0)
var stun: bool = false
var sin_value: int = 0
var time = 0
var t = 0.5 # influences moving towards target
var p = 0.1 # influences oscillatings

func fire(forward: Vector2, speed: float): #true = normal, false = stun
	velocity = forward * speed
	look_at(position + forward)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_time_to_live_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.hit(1)
		queue_free()
	elif body is Runner:
		body.hit(1)
		queue_free()
	elif body is guardRight:
		reflect_off_guard(body)
	# elif body.collision_layer == 5:
		# print("hit wall")
		# reflect_off_wall(body)
		
func reflect_off_wall(body: Node2D) -> void:
	var normal = velocity.normalized() * -1  # Reflect off in opposite direction
	velocity = velocity.bounce(normal)  # Use bounce method to reflect velocity

func reflect_off_guard(body: Node2D) -> void:
	var normal = (position - body.position).normalized()
	velocity = velocity.bounce(normal)  # Use Godot's bounce method to reflect velocity off the guard
