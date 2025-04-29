class_name GameOverArea extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(GlobalVars.Groups.OBSTACLE):
		var obstacle: Obstacle = body
		if obstacle.is_in_group(GlobalVars.Groups.HEALTH_REPLENISH_OBSTACLE):
			pass
		elif obstacle.is_in_group(GlobalVars.Groups.BOMB_OBSTACLE):
			GlobalVars.player.health = 0
			GlobalVars.is_game_over = true
		elif obstacle.is_in_group(GlobalVars.Groups.GOLD_OBSTACLE):
			pass
		else:
			GlobalVars.player.take_damage(obstacle.health)

		if obstacle.animation_player.has_animation("destroy"):
			obstacle.animation_player.play("destroy")
		else:
			obstacle.queue_free()
