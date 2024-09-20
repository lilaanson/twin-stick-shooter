extends State

@export var chase_speed : float = 3000.0
var target : CharacterBody2D

func process_state(delta: float):
	body.velocity = (target.position - body.position).normalized() * chase_speed * delta
	body.move_and_slide()
