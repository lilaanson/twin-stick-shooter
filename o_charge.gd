extends Area2D

var charging = false

func _process(delta: float) -> void:
	if not charging:
		get_tree().get_root().get_node("Node2D/player").charging(false)
	else:
		get_tree().get_root().get_node("Node2D/player").charging(true)

func _on_body_entered(body: Node2D) -> void:
	charging = true

func _on_body_exited(body: Node2D) -> void:
	charging = false
