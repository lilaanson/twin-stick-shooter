# SFX
# O2 REFILL/DEATH
# add new runner enemy
# add warning when low


extends CharacterBody2D
class_name Player

const max_health: int = 10

@export var projectile_scene: Resource
@export var move_speed: float = 40.0


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
var death_replay_valid = false
var facing_angle : int = 0
var o_charging: bool = false
var health_charging: bool = false
var current_level: int = 0
var paused = false
var slime_tally = 7
var wave_triggered = false
var wave_finished = false
var guard_tally = 1
var enemies_array = ["Node2D/enemy9","Node2D/enemy10","Node2D/enemy11","Node2D/enemy12","Node2D/enemy13","Node2D/enemy14","Node2D/enemy15","Node2D/enemy16","Node2D/enemy17","Node2D/enemy18",]
var enemies_array2 = ["Node2D/enemy19","Node2D/enemy20","Node2D/enemy21","Node2D/enemy22","Node2D/enemy23","Node2D/enemy24","Node2D/enemy25","Node2D/enemy26","Node2D/enemy27","Node2D/enemy28","Node2D/enemy29","Node2D/enemy30","Node2D/enemy31","Node2D/enemy32","Node2D/enemy33","Node2D/enemy34"]
var removed_enemies = false
var added_enemies = false
var respawn_2 = false
var respawn_3 = false
var runner_tally = 1


var bg_music: AudioStreamPlayer = AudioStreamPlayer.new()
var sound_effect : AudioStreamPlayer = AudioStreamPlayer.new()

func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			var current_sound = load ("res://environment/shoot.wav")
			sound_effect.volume_db = 1.99 # might need to increase
			sound_effect.stream = current_sound
			sound_effect.play()
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
		# facing_angle = rad_to_deg(velocity.angle()) + 180
		# if (facing_angle > 315 or facing_angle < 45):
		$knifeSprite.visible = true
		var collision = get_slide_collision(0) 
		if (collision):
			if collision.get_collider().is_in_group("guardRight"):
				get_tree().get_root().get_node("Node2D/guardRight").hit(1)
	else:
		using_knife = false
		$knifeSprite.visible = false
	if (Input.is_action_pressed("playing")):
		playing = true
	if (Input.is_action_pressed("replay_death") and death_replay_valid):
		get_tree().change_scene_to_file("res://main.tscn")

func _ready() -> void:
	
	bg_music.stream = load("res://environment/370801__romariogrande__space-chase.wav")
	bg_music.autoplay = true
	add_child(bg_music)
	add_child(sound_effect)

# func set_health_bar() -> void:
	# get_tree().get_root().get_node("Node2D/HUD/healthBar").value = hp_player
	
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

func laser():
	$Camera2D.start_shake(.5, .1)
	PlayerHealthManager.change_health(true, 1,false)
	var current_sound = load ("res://environment/damage.ogg")
	sound_effect.volume_db = 0 # might need to increase
	sound_effect.stream = current_sound
	sound_effect.play()
	
func slime_counter():
	slime_tally -= 1

func guard_counter():
	guard_tally -= 1

func runner_counter():
	runner_tally -= 1
	print("RUNNER TALLYYYYYYYYYYYY: "+str(runner_tally))
	
func level_manager(): # add key commands to start screen
	# probably want to trigger in beginning as well if time
	if current_level == 0:
		get_tree().get_root().get_node("Node2D/HUD/waveLabel").text = "FIRST WAVE"
		paused = false
		get_tree().get_root().get_node("Node2D/guardRight").position.x = -200 # originally 40
		get_tree().get_root().get_node("Node2D/runner").position.x = -200 # originally 106
		if removed_enemies == false:
			for enemy in enemies_array:
				get_tree().get_root().get_node(enemy).position.x -= 800 # originally 25
			for enemy2 in enemies_array2:
				get_tree().get_root().get_node(enemy2).position.x -= 800 # originally 25
			removed_enemies = true
		if not wave_finished and playing:
			play_wave()
		if wave_finished:
			current_level = 1
			wave_finished = false
	if current_level == 1:
		print(str(slime_tally))

		get_tree().get_root().get_node("Node2D/HUD/waveLabel").text = "SECOND WAVE"
		if slime_tally <= 0: # RESET TO 0 WHEN NOT A TST! inc o2 depletion
			paused = true
			if not wave_finished: 
				play_wave()
			else:
				slime_tally = 10
				current_level = 2 # FIX
				wave_finished = false
	if current_level == 2: #enemy9, normally 25
		print(str(slime_tally)+", "+str(guard_tally))

		if respawn_2 == false:
			get_tree().get_root().get_node("Node2D/guardRight").position.x = 40 # originally 40
			for enemy in enemies_array:
				get_tree().get_root().get_node(enemy).position.x += 800 # originally 25
			respawn_2 = true
		get_tree().get_root().get_node("Node2D/HUD/waveLabel").text = "FINAL WAVE"

		paused = false
		if guard_tally <= 0 and slime_tally <= 0: # RESET TO 0 WHEN NOT A TST!
			paused = true
			if not wave_finished: 
				play_wave()
			if wave_finished:
				slime_tally = 16
				current_level = 3
				#figure out lvl 2 details
				# will need to reset slime counter to new amount
				wave_finished = false
	if current_level == 3:
		print(str(slime_tally)+", "+str(runner_tally))
		if respawn_3 == false:
			get_tree().get_root().get_node("Node2D/runner").position.x = 106 # originally 106
			for enemy2 in enemies_array2:
				get_tree().get_root().get_node(enemy2).position.x += 800 # originally 25
			respawn_3 = true	
		paused = false
		if slime_tally <= 0 and runner_tally <= 0:
			playing = false
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = true
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").text = """SHIP SECURED!
			PRESS R TO PLAY AGAIN"""
			if flashing_timer <= 50:
				get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = true
				flashing_timer += 1
			elif flashing_timer <= 100:
				get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = false
				flashing_timer += 1
			else:
				flashing_timer = 0

				
func play_wave(): #wave hidden at 290. new func to reset health and o2
	if get_tree().get_root().get_node("Node2D/HUD/oBar").value <= 100:
		get_tree().get_root().get_node("Node2D/HUD/oBar").value = 100 # NOT WORKIKNG
	
	var current_pos = get_tree().get_root().get_node("Node2D/HUD/waveLabel").position.x
	if current_pos >= -250:
		get_tree().get_root().get_node("Node2D/HUD/waveLabel").position.x -= 4
	else:
		wave_finished = true
		paused = false
		get_tree().get_root().get_node("Node2D/HUD/waveLabel").position.x = 290 # might have to mess w these numbers to hide at all texts

func charging(is_charging): # add default false back to o node
	if is_charging:
		get_tree().get_root().get_node("Node2D/HUD/oBar").value += 5
		if get_tree().get_root().get_node("Node2D/HUD/oBar").max_value == get_tree().get_root().get_node("Node2D/HUD/oBar").value:
			PlayerHealthManager.change_health(false, 1,true)

	elif playing and not paused:
		if get_tree().get_root().get_node("Node2D/HUD/oBar").value <= 0:
			PlayerHealthManager.change_health(true, 1, true)
		else:
			get_tree().get_root().get_node("Node2D/HUD/oBar").value -= 0.4
		
		
func _physics_process(delta):
	level_manager()
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
					PlayerHealthManager.change_health(true, 50,false)
					
					hurt_by_runner = true
			else:
				runner_timing -=1
		elif collision.get_collider().is_in_group("mainEnemy"):
			$Camera2D.start_shake(.5, .1)
			PlayerHealthManager.change_health(true, 1,false)
			var current_sound = load ("res://environment/damage.ogg")
			sound_effect.volume_db = 0 # might need to increase
			sound_effect.stream = current_sound
			sound_effect.play()			

	var hp_player = get_tree().get_root().get_node("Node2D/HUD").return_hp()
	
	if hp_player > 0 and playing: # might have to rephrase
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
	if hp_player <= 0 and not paused: 
		if played_death_anim == false:
			$AnimationPlayer.play("player_death")
		else:
			$AnimationPlayer.play("player_on_ground")
			$Camera2D.start_shake(.5, .1)
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = true
			get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").text = """MISSION FAILED!
			PRESS R TO PLAY AGAIN"""
			death_replay_valid = true
			if flashing_timer <= 50:
				get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = true
				flashing_timer += 1
			elif flashing_timer <= 100:
				get_tree().get_root().get_node("Node2D/HUD/descriptionLabel").visible = false
				flashing_timer += 1
			else:
				flashing_timer = 0
			#SHOW REPLAY ACTIONS
	else:
		
		if (velocity.length() > 0):
			facing_angle = rad_to_deg(velocity.angle()) + 180
		var angle = facing_angle

		if using_knife:
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
	
# When dead do this
# get_tree().change_scene_to_file("res://main.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "player_death"):
		played_death_anim = true
