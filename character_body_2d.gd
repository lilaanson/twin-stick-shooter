extends CharacterBody2D

@export var playerCheck = CharacterBody2D
@export var spriteCover = CharacterBody2D


func _physics_process(delta: float) -> void:
	var x_pos = playerCheck.position.x
	var y_pos = playerCheck.position.y
	spriteCover.position.x = x_pos
	spriteCover.position.y = y_pos
	
