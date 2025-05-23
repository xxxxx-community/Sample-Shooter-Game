extends Node

signal game_over()
signal paused()
signal resume()
signal mute_toggled()
signal score_changed(value: int)

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(value)
var obstacle_spawner: ObstacleSpawner
var world: World
var player: Player
var music_volume: int = 50
var sfx_volume: int
var difficulty: int = 3
var is_muted: bool = false:
	set(value):
		is_muted = value
		mute_toggled.emit(value)
var process_enabled: bool:
	get:
		return not is_paused and not is_game_over
var is_paused: bool = false:
	set(value):
		is_paused = value
		if value:
			paused.emit()
		else:
			resume.emit()
var is_game_over: bool = false:
	set(value):
		is_game_over = value
		if value:
			game_over.emit()
		else:
			score = 0

class Groups:
	static var BULLET = "bullet"
	static var OBSTACLE = "obstacle"
	static var GAME_OVER_AREA = "game_over_area"
	static var HEALTH_REPLENISH_OBSTACLE = "health_replenish_obstacle"
	static var BOMB_OBSTACLE = "bomb_obstacle"
	static var GOLD_OBSTACLE = "gold_obstacle"

func _process(_delta):
	if Input.is_action_just_pressed("mute"):
		is_muted = not is_muted
