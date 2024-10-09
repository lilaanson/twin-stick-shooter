extends CharacterStateMachine
class_name Enemy

@export var hp: int = 3

func hit(damage_number: int):
	hp -= damage_number
	if (hp <= 0):
		get_tree().get_root().get_node("Node2D/player").slime_counter()
		ScoreManager.add_score(100)
		queue_free()
