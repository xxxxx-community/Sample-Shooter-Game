class_name GoldObstacle extends Obstacle

@export var cost: int

func _on_destroyed() -> void:
	GlobalVars.score += cost
	if animation_player.has_animation("destroy"):
		animation_player.play("destroy")
	else:
		queue_free()
