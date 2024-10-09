extends Sprite2D

# Variables for controlling the transparency oscillation
var speed = 5.0  # Speed of the oscillation
var min_alpha = 0.0  # Minimum transparency (fully transparent)
var max_alpha = 1.0  # Maximum transparency (fully visible)
var time_passed = 0.0  # Keeps track of time for sine wave

func _process(delta):
	# Increment time for the sine wave
	time_passed += delta * speed

	# Calculate the alpha value using a sine wave oscillation
	var alpha = ((sin(time_passed) + 1.0) / 2.0) * (max_alpha - min_alpha) + min_alpha

	# Set the transparency by modifying the 'modulate' property
	modulate.a = alpha  # Gradually changes between 0 and 1
