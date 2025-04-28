extends Node

signal game_over()
signal paused()
signal resume()

var score: int = 0
var obstacle_spawner: ObstacleSpawner
var world: World
var player: Player
var volume: int = 50
var difficulty: int = 3
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
