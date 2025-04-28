extends Control

@onready var volume_value_label: Label = %VolumeValueLabel
@onready var texture_rect: TextureRect = %TextureRect
@onready var difficulty_value_label: Label = %DifficultyValueLabel
@onready var volume_scroll_bar: HScrollBar = %VolumeScrollBar
@onready var difficulty_scroll_bar: HScrollBar = %DifficultyScrollBar

func _ready() -> void:
	difficulty_scroll_bar.set_value_no_signal(GlobalVars.difficulty)
	volume_scroll_bar.set_value_no_signal(GlobalVars.volume)
	volume_value_label.text = str(GlobalVars.volume)
	difficulty_value_label.text = str(GlobalVars.difficulty)

func _on_volume_scroll_bar_value_changed(value: float) -> void:
	GlobalVars.volume = int(value)
	volume_value_label.text = str(GlobalVars.volume)
	

func _on_difficulty_scroll_bar_value_changed(value: float) -> void:
	GlobalVars.difficulty = int(value)
	difficulty_value_label.text = str(GlobalVars.difficulty)


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
