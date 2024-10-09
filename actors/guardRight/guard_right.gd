extends CharacterStateMachine
class_name guardRight


@export var hp: int = 3

@export var ProjectileScene: Resource

func fire_projectile():
	var projectile_instance = ProjectileScene.instantiate()
	projectile_instance.position = $projectileRefPoint.global_position
	get_parent().add_child(projectile_instance)
	projectile_instance.fire(1000)  # Assuming 'fire()' is the function you want to call in your projectile script


func hit(damage_number: int):
	hp -= damage_number
	if (hp <= 0):
		get_tree().get_root().get_node("Node2D/player").guard_counter()
		queue_free()
		
		
