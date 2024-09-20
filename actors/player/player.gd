extends CharacterBody2D

@export var projectile_scene: Resource
@export var move_speed: float = 100.0
@export var hp_player: int = 2
@export var health_label: RichTextLabel


var can_move_right: bool = true
var can_move_left: bool = true
var can_move_up: bool = true
var can_move_down: bool = true
var low_timer: int = 400
var counting_down: bool = false
var buff_on: bool = false
var buff_count: int = 50



func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			
			var projectile_forward = position.direction_to(get_global_mouse_position())
			new_projectile.fire(projectile_forward, 500.0, !counting_down)
			new_projectile.position = $projectileRefPoint.global_position
	if (Input.is_action_just_pressed("shoot_burst")):
		#UPDATE THESE FOR RIGHT DIRECTION
		var new_projectile1 = projectile_scene.instantiate()
		get_parent().add_child(new_projectile1)
		var new_projectile2 = projectile_scene.instantiate()
		get_parent().add_child(new_projectile2)
		var new_projectile3 = projectile_scene.instantiate()
		get_parent().add_child(new_projectile3)
		
		var projectile_forward1 = Vector2.from_angle(rotation + 2*PI/3)
		new_projectile1.fire(projectile_forward1, 1000.0, counting_down)
		new_projectile1.position = $projectileRefPoint.global_position
		var projectile_forward2 = Vector2.from_angle(rotation - 2*PI/3)
		new_projectile2.fire(projectile_forward2, 1000.0, counting_down)
		new_projectile2.position = $projectileRefPoint.global_position
		var projectile_forward3 = Vector2.from_angle(rotation)
		new_projectile3.fire(projectile_forward3, 1000.0, counting_down)
		new_projectile3.position = $projectileRefPoint.global_position

func _physics_process(delta):
	if (buff_on):
		if buff_count <= 0:
			buff_on = false
			buff_count = 50
		else:
			buff_count -= 1
	if (counting_down):
		print(low_timer)
		if (low_timer<= 0):
			counting_down = false
			hp_player = 2
			health_label.text = "[color=black]HEALTH: HIGH[/color]"
			low_timer = 400
		low_timer -= 1
	var collision: KinematicCollision2D = move_and_collide(velocity * delta) ##position?
	if (collision): ##need to add a reset to true
		#if collision.collider.name === "enemy"
		if (hp_player==2):
			print("first collision")
			health_label.text = "[color=black]HEALTH: LOW[/color]"
			hp_player -= 1
			counting_down = true
			buff_on = true
		elif (not buff_on):
			health_label.text = "DEAD"
		

		#print("COLLIISION !!")
		#if collision.get_collider().is_in_group("topWall"):
			#can_move_up = false
		#elif collision.get_collider().is_in_group("bottomWall"):
			#can_move_down = false
			#print("hit bottom")
			#print("Collision detected with: ", collision.collider.name)
		#elif collision.get_collider().is_in_group("rightWall"):
			#can_move_right = false
		#elif collision.get_collider().is_in_group("leftWall"):
			#can_move_left = false
	#look_at(get_viewport().get_mouse_position())
	if (can_move_right and can_move_left and can_move_up and can_move_down):
		velocity = Input.get_vector("move_left", \
			"move_right", \
			"move_up", \
			"move_down") * move_speed
		move_and_slide()
	elif (can_move_right and can_move_left and can_move_up):
		velocity = Input.get_vector("move_left", \
			"move_right", \
			"move_up", str(0))* move_speed
		move_and_slide()
		
	#math to sort dir animation
	var angle = rad_to_deg(velocity.angle()) + 180
	if (velocity.length() < 10):
		$AnimationPlayer.play("idle_front_temp")
	else:
		if (angle > 135 and angle < 225):
			$AnimationPlayer.play("walk_right")
		elif (angle > 225 and angle < 315):
			$AnimationPlayer.play("walk_front")
		elif (angle > 315 or angle < 45):
			$AnimationPlayer.play("walk_left")
		elif (angle > 45 and angle < 135):
			$AnimationPlayer.play("walk_back")
