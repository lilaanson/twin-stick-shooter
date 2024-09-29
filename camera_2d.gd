extends Camera2D  # For 2D camera; change to Camera3D for 3D

# Variables to control the shake intensity and duration
var shake_intensity = 0
var shake_timer = 0
var original_intensity = 0  # Store the original intensity

# Call this function to start the screen shake
func start_shake(intensity: float, duration: float):
	shake_intensity = intensity
	original_intensity = intensity  # Keep track of the starting intensity
	shake_timer = duration

# Update function to handle the shake effect
func _process(delta: float):
	if shake_timer > 0:
		shake_timer -= delta
		# Gradually reduce intensity over time
		shake_intensity = original_intensity * (shake_timer / shake_timer + delta)  # Damping effect
		# Apply random offset to the camera position
		offset = Vector2(randf() * shake_intensity * 2 - shake_intensity, randf() * shake_intensity * 2 - shake_intensity)
	else:
		# Reset the camera position when the shake ends
		offset = Vector2.ZERO
