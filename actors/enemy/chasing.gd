extends State

@export var chase_speed : float = 1000.0
var target : CharacterBody2D
var timer = 0
var moving = false
var first_run = true

func process_state(delta: float):
	if target.is_in_group("power_ups"):
		pass
	else:
		body.velocity = (target.position - body.position).normalized() * chase_speed * delta
		if (first_run):
			if timer < 12:
				timer += 1
			else:
				timer = 0
				moving = true
				first_run = false
		else: # if not first time, run thru 36 and 24
			if (moving):
				if timer < 36:
					body.move_and_slide()
					timer += 1
				else:
					timer = 0
					moving = false
			if (not moving):
				if timer <= 24:
					timer += 1
				else:
					timer = 0
					moving = true
			
