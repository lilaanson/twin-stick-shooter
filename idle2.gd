extends State

var detect_range : Area2D
var chasing_state : State
var animation_player: AnimationPlayer

func initialize():
	detect_range = body.get_node("DetectionRange")
	chasing_state = get_parent().get_node("chasing")
	animation_player = body.get_node("AnimationPlayer")

func process_state(delta: float):
	animation_player.play("runner_idle")
	var potential_targets = detect_range.get_overlapping_bodies()
	if (not potential_targets.is_empty()):
		chasing_state.target = (potential_targets[0] as CharacterBody2D)
		change_state.emit(chasing_state)
