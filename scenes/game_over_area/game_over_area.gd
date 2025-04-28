class_name GameOverArea extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(GlobalVars.Groups.OBSTACLE):
		var _obstacle: Obstacle = body
		GlobalVars.is_game_over = true
