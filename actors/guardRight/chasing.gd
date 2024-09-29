extends State

@export var chase_speed : float = 1000.0
var target : CharacterBody2D
var timer = 0
var moving = false
var first_run = true
var animation_player : AnimationPlayer
var detect_range : Area2D
var idle_state : State
var target_tally = 0
var shoot_increment = 0

func initialize():
	animation_player = body.get_node("AnimationPlayer")
	detect_range = body.get_node("DetectionRange")
	idle_state = get_parent().get_node("idle")


func process_state(delta: float):
	if target.is_in_group("power_ups"):
		pass
	else:
		body.fire_projectile()
		animation_player.play("right_shooter_enemy_chasing")
		#body.velocity = (target.position - body.position).normalized() * chase_speed * delta
		# body.move_and_slide()
		var potential_targets = detect_range.get_overlapping_bodies()
		if (potential_targets.is_empty()):
			change_state.emit(idle_state)

				
			
