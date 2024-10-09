extends CanvasLayer

var hp_player = 100

func _ready() -> void:
	PlayerHealthManager.health_updated.connect(_update_health)


func _update_health(new_score: float):
	hp_player = new_score
	$healthBar.value = new_score
	
func return_hp():
	return(hp_player)
