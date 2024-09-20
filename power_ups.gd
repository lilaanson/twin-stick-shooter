extends CharacterBody2D

@export var charge: RichTextLabel
@export var hiddenChargeText: RichTextLabel


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta) ##position?
	if (collision): ##need to add a reset to true
		print("collision!")
		#if collision.collider.name === "enemy"
		if collision.get_collider().is_in_group("power_ups"):
			queue_free()
			var current_text = charge.text
			if hiddenChargeText.text == "false":
				hiddenChargeText.text == "true"
				charge.text = "CHARGED"

			
			
