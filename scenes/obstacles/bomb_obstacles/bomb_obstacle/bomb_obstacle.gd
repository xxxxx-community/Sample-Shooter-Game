class_name BombObstacle extends Obstacle

@export var explosion_distance: float

var obstacles_in_explosion_area


func blow_up():
	for node in GlobalVars.world.obstacle_spawner.obstacles_node_container.get_children():
		if global_position.distance_to(node.global_position) <= explosion_distance:
			if node.is_in_group(GlobalVars.Groups.OBSTACLE) and not node.is_in_group(GlobalVars.Groups.BOMB_OBSTACLE):
				var obstacle: Obstacle = node
				obstacle.destroyed.emit()


func _on_destroyed() -> void:
	blow_up()
	super()
