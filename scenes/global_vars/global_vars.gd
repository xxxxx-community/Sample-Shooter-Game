extends Node

signal game_over()
signal paused()
signal resume()
signal mute_toggled()

var score: int = 0
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

class Groups:
	static var BULLET = "bullet"
	static var OBSTACLE = "obstacle"
	static var GAME_OVER_AREA = "game_over_area"

func _process(_delta):
	if Input.is_action_just_pressed("mute"):
		is_muted = not is_muted
