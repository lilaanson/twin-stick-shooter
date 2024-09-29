extends Node2D

const max_health: int = 10
var health = max_health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/healthBar.max_value = max_health
	set_health_bar()

func set_health_bar() -> void:
	$HUD/healthBar.value = health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
