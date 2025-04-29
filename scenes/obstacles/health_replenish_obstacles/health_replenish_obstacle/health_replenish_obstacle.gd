class_name HealthReplenishObstacle extends Obstacle

@export var recoverable_health: int

func _on_destroyed() -> void:
	GlobalVars.player.replenish_health(recoverable_health)
	if animation_player.has_animation("destroy"):
		animation_player.play("destroy")
	else:
		queue_free()
