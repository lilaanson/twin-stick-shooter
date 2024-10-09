extends Node


signal health_updated(new_health: int)

var current_health: int = 100
var slowed_timer: int = 0

func _ready():
	health_updated.emit(current_health)

func change_health(subtract: bool, num: float, slowed: bool):
	if slowed:
		if slowed_timer % 15 == 0:
			if subtract:
				current_health -= num
			elif not subtract:
				current_health += num
			health_updated.emit(current_health)
	else:
		if subtract:
			current_health -= num
		elif not subtract:
			current_health += num
		health_updated.emit(current_health)
	slowed_timer += 1
	print(current_health)
