extends State

@export var chase_speed : float = 4500.0
var target : CharacterBody2D
var timer = 0
var moving = false
var first_run = true
var animation_player : AnimationPlayer
var runner_timing: int = 1000
var alive: bool = true


func initialize():
	animation_player = body.get_node("AnimationPlayer")


func process_state(delta: float):
	if target.is_in_group("power_ups"):
		pass
	else:
		body.velocity = (target.position - body.position).normalized() * chase_speed * delta
		body.move_and_slide()
		
		var angle = rad_to_deg(body.velocity.angle()) + 180
		if (body.velocity.length() < 10):
			if alive:
				animation_player.play("runner_idle")
			if not alive:
				animation_player.play("runner_explosion")
				get_tree().get_root().get_node("Node2D/player").runner_sound(true)
		else:
			if (angle > 135 and angle < 225):
				animation_player.play("runner_right")
			elif (angle > 225 and angle < 315):
				animation_player.play("runner_front")
			elif (angle > 315 or angle < 45):
				animation_player.play("runner_left")
			elif (angle > 45 and angle < 135):
				animation_player.play("runner_back")
	
func runner_death(dead):
	chase_speed = 0
	alive = false
