class_name World extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_over_box: VBoxContainer = %GameOverBox
@onready var paused_box: VBoxContainer = %PausedBox
@onready var score_label: Label = %ScoreLabel
@onready var health_label: Label = %HealthLabel
@onready var obstacle_spawner: ObstacleSpawner = $ObstaclesSpawner

@export var bullets_node_container: Node2D

func _enter_tree() -> void:
	GlobalVars.world = self


func _ready() -> void:
	animation_player.play("obstacle_spawn_rate")
	GlobalVars.game_over.connect(func (): game_over_box.visible = true)
	GlobalVars.paused.connect(func (): paused_box.visible = true)
	GlobalVars.resume.connect(func (): paused_box.visible = false)
	GlobalVars.score_changed.connect(func (value): score_label.text = str(value))
	GlobalVars.player.health_reduced.connect(func (old_heath: int, new_health: int): health_label.text = str(new_health))
	health_label.text = str(GlobalVars.player.health)


func _process(_delta):
	if Input.is_action_just_pressed("pause") and not GlobalVars.is_paused:
		GlobalVars.is_paused = true
	elif Input.is_action_just_pressed("resume") and GlobalVars.is_paused:
		GlobalVars.is_paused = false


func _on_resume_button_pressed() -> void:
	GlobalVars.is_paused = false


func _on_back_to_menu_button_pressed() -> void:
	GlobalVars.is_paused = false
	GlobalVars.is_game_over = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn") 


func _on_play_again_button_pressed() -> void:
	GlobalVars.is_paused = false
	GlobalVars.is_game_over = false
	get_tree().reload_current_scene()
