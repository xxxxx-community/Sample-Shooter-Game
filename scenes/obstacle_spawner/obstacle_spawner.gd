class_name ObstacleSpawner extends Node

@export var markers: Array[Marker2D] = []
@export var obstacle_spawn_delay: float:
	set(value):
		obstacle_spawn_delay = value
		if obstacle_spawn_timer:
			obstacle_spawn_timer.wait_time = obstacle_spawn_delay
@export var enabled: bool = true
@export var obstacles: Array[PackedScene]
@export var obstacles_node_container: Node2D
@export var markers_node_container: Node2D
@onready var obstacles_file_name_stack: Array[String] = []

@onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer


signal obstacle_spawned(obstacle: Obstacle)

func _ready():
	obstacle_spawn_timer.wait_time = obstacle_spawn_delay
	obstacle_spawn_timer.start()
	if markers_node_container:
		markers.append_array(markers_node_container.get_children())
	GlobalVars.game_over.connect(func (): obstacle_spawn_timer.paused = true)
	GlobalVars.paused.connect(func (): obstacle_spawn_timer.paused = true)
	GlobalVars.resume.connect(func (): obstacle_spawn_timer.paused = false)
	obstacles_file_name_stack.resize(100)
	obstacles_file_name_stack.fill("res://scenes/obstacles/obstacle_level_1/obstacle_level_1.tscn")


func _enter_tree() -> void:
	GlobalVars.obstacle_spawner = self


func spawn_obstacle(obstacle_scene: PackedScene, marker: Marker2D) -> void:
	if GlobalVars.process_enabled and enabled:
		var obstacle: Obstacle = obstacle_scene.instantiate()
		obstacle.global_position = marker.global_position
		obstacles_node_container.add_child(obstacle)
		obstacle_spawned.emit(obstacle)


func _on_obstacle_spawn_timer_timeout() -> void:
	var count: int = randi_range(1, 3)
	markers.shuffle()
	var markers_to_spawn_obstacle = markers.slice(0, count + 1)
	while count > 0:
		if obstacles_file_name_stack:
			spawn_obstacle(load(obstacles_file_name_stack.pop_front()), markers_to_spawn_obstacle.pop_front())
		count -= 1
