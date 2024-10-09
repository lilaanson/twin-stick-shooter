extends CharacterStateMachine
class_name Runner

@export var hp: int = 3

func hit(damage_number: int):
	hp -= damage_number
	if (hp <= 0):
		get_tree().get_root().get_node("Node2D/player").runner_counter()
		queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "runner_explosion"):
		queue_free()
		# $AnimationPlayer.play("runner_dead")
