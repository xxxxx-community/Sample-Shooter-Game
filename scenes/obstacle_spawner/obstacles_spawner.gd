class_name ObstacleSpawner extends Node

@onready var spawn_timer: Timer = $SpawnTimer

@export var obstacles_node_container: Node2D
@export var markers_node_container: Node2D
@export var markers: Array[Marker2D]
@export var spawn_delay: float
@export var obstacles: Dictionary[int, PackedScene] = {}

signal obstacle_spawned(obstacle: Obstacle)

func _ready():
	GlobalVars.paused.connect(func (): spawn_timer.paused = true)
	GlobalVars.resume.connect(func (): spawn_timer.paused = false)
	GlobalVars.game_over.connect(func (): spawn_timer.paused = false)
	markers.append_array(markers_node_container.get_children())
	spawn_timer.start(spawn_delay)


func spawn_obstacle(obstacle_scene: PackedScene, marker: Marker2D) -> void:
	if GlobalVars.process_enabled:
		var obstacle: Obstacle = obstacle_scene.instantiate()
		obstacle.global_position = marker.global_position
		obstacles_node_container.add_child(obstacle)
		obstacle_spawned.emit(obstacle)


func _on_spawn_timer_timeout() -> void:
	var count: int = randi_range(1, 3)
	markers.shuffle()
	var markers_to_spawn = markers.slice(0, count)
	var obstacle_scene: PackedScene
	if randi_range(1, 6) == 1 and GlobalVars.player.health < GlobalVars.player.max_health:
		obstacle_scene = obstacles.get(6)
		spawn_obstacle(obstacle_scene, markers_to_spawn[0])
	elif randi_range(1, 6) == 1 and GlobalVars.score > 50:
		obstacle_scene = obstacles.get(7)
		spawn_obstacle(obstacle_scene, markers_to_spawn[0])
	elif randi_range(1, 6) == 1 and GlobalVars.score > 0:
		obstacle_scene = obstacles.get(8)
		spawn_obstacle(obstacle_scene, markers_to_spawn[0])
	else:
		for marker_to_spawn in markers_to_spawn:
			if GlobalVars.score < 30:
				obstacle_scene = obstacles.get(clamp(1, 1, GlobalVars.difficulty))
			elif GlobalVars.score < 60:
				obstacle_scene = [obstacles.get(clamp(1, 1, GlobalVars.difficulty)), obstacles.get(clamp(2, 1, GlobalVars.difficulty))].pick_random()
			elif GlobalVars.score < 90:
				obstacle_scene = [obstacles.get(clamp(1, 1, GlobalVars.difficulty)), obstacles.get(clamp(2, 1, GlobalVars.difficulty)), obstacles.get(clamp(3, 1, GlobalVars.difficulty))].pick_random()
			elif GlobalVars.score < 120:
				obstacle_scene = [obstacles.get(clamp(2, 1, GlobalVars.difficulty)), obstacles.get(clamp(3, 1, GlobalVars.difficulty)), obstacles.get(clamp(4, 1, GlobalVars.difficulty))].pick_random()
			else:
				obstacle_scene = [obstacles.get(clamp(3, 1, GlobalVars.difficulty)), obstacles.get(clamp(4, 1, GlobalVars.difficulty)), obstacles.get(clamp(5, 1, GlobalVars.difficulty))].pick_random()
				
			spawn_obstacle(obstacle_scene, marker_to_spawn)
		
	
	spawn_timer.start(spawn_delay)
