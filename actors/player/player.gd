extends CharacterBody2D
class_name Player

const max_health: int = 10

@export var projectile_scene: Resource
@export var move_speed: float = 40.0
@export var hp_player = max_health


var can_move_right: bool = true
var can_move_left: bool = true
var can_move_up: bool = true
var can_move_down: bool = true
var runner_timing: int = 10
var using_knife = false
var played_death_anim = false
var playing = false
var flashing_timer = 0
var played_explosion = false
var hurt_by_runner = false

var bg_music: AudioStreamPlayer = AudioStreamPlayer.new()
var sound_effect : AudioStreamPlayer = AudioStreamPlayer.new()

func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			$Camera2D.start_shake(.5, .1)
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			
			var projectile_forward = position.direction_to(get_global_mouse_position())
			new_projectile.fire(projectile_forward, 500.0)
			new_projectile.position = $projectileRefPoint.global_position
	if (Input.is_action_just_pressed("shoot_burst")):
			$Camera2D.start_shake(.5, .1)
			#UPDATE THESE FOR RIGHT DIRECTION
			var new_projectile1 = projectile_scene.instantiate()
			get_parent().add_child(new_projectile1)
			var new_projectile2 = projectile_scene.instantiate()
			get_parent().add_child(new_projectile2)
			var new_projectile3 = projectile_scene.instantiate()
			get_parent().add_child(new_projectile3)
			
			var projectile_forward1 = Vector2.from_angle(rotation + 2*PI/3)
			new_projectile1.fire(projectile_forward1, 1000.0)
			new_projectile1.position = $projectileRefPoint.global_position
			var projectile_forward2 = Vector2.from_angle(rotation - 2*PI/3)
			new_projectile2.fire(projectile_forward2, 1000.0)
			new_projectile2.position = $projectileRefPoint.global_position
			var projectile_forward3 = Vector2.from_angle(rotation)
			new_projectile3.fire(projectile_forward3, 1000.0)
			new_projectile3.position = $projectileRefPoint.global_position
			
		
	if (Input.is_action_pressed("use_knife")):
		using_knife = true
		$knifeSprite.visible = true
	else:
		using_knife = false
		$knifeSprite.visible = false
	if (Input.is_action_pressed("playing")):
		playing = true

func _ready() -> void:
	get_tree().get_root().get_node("Node2D/HUD/healthBar").max_value = max_health
	set_health_bar()
	
	bg_music.stream = load("res://environment/370801__romariogrande__space-chase.wav")
	bg_music.autoplay = true
	add_child(bg_music)
	add_child(sound_effect)

func set_health_bar() -> void:
	get_tree().get_root().get_node("Node2D/HUD/healthBar").value = hp_player
	
func guard_sound()-> void:
	var current_sound = load ("res://environment/277218__thedweebman__8-bit-laser.wav")
	sound_effect.stream = current_sound
	sound_effect.play()
	
func runner_sound(death) -> void:
	# true: death, false: trigger
	if death and not played_explosion:
		var current_sound = load ("res://environment/explode.wav")
		sound_effect.stream = current_sound
		sound_effect.play()
		played_explosion = true

func _physics_process(delta):
	#var collision: KinematicCollision2D = move_and_collide(velocity * delta) ##position?
	move_and_slide()
	var collision = get_slide_collision(0) 
	if (collision): ##need to add a reset to true
		#if collision.collider.name === "enemy"	
		if collision.get_collider().is_in_group("power_ups"):
			collision.get_collider().queue_free()
		elif collision.get_collider().is_in_group("runner"):
			if runner_timing <= 0:
				get_tree().get_root().get_node("Node2D/runner/States/chasing").runner_death(true)
				$Camera2D.start_shake(3, 0.7)  # Intensity: 10, Duration: 0.5 seconds
				if not hurt_by_runner:
					hp_player -= 5
					hurt_by_runner = true
			else:
				runner_timing -=1
		elif collision.get_collider().is_in_group("mainEnemy"):
			$Camera2D.start_shake(.5, .1)
			hp_player -= .1
		elif collision.get_collider().is_in_group("laser"):
			print("hitting laser")
			$Camera2D.start_shake(.5, .1)
			hp_player -= .1
			
	set_health_bar()
	if hp_player > 0 and playing:
		get_tree().get_root().get_node("Node2D/HUD/titleLabel").visible = false
		get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = false
		velocity = Input.get_vector("move_left", \
			"move_right", \
			"move_up", \
			"move_down") * move_speed
		move_and_slide()
	elif hp_player > 0: # alive but not yet playing
		if flashing_timer <= 50:
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = true
			flashing_timer += 1
		elif flashing_timer <= 100:
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = false
			flashing_timer += 1
		else:
			flashing_timer = 0
	else:
		$Camera2D.start_shake(0,0)
		
	#math to sort dir animation
	if hp_player <= 0:
		if played_death_anim == false:
			$AnimationPlayer.play("player_death")
		else:
			$AnimationPlayer.play("player_on_ground")
	else:
		var angle = rad_to_deg(velocity.angle()) + 180
		if using_knife:
			if (angle > 315 or angle < 45):
				$AnimationPlayer.play("fighting_left")
				$Camera2D.start_shake(.5, .1)
		else:
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
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "player_death"):
		played_death_anim = true
