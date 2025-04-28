extends Control

@onready var sfx_volume_value_label: Label = %SFXVolumeValueLabel
@onready var sfx_volume_scroll_bar: HScrollBar = %SFXVolumeScrollBar
@onready var music_volume_value_label: Label = %MusicVolumeValueLabel
@onready var music_volume_scroll_bar: HScrollBar = %MusicVolumeScrollBar
@onready var difficulty_value_label: Label = %DifficultyValueLabel
@onready var difficulty_scroll_bar: HScrollBar = %DifficultyScrollBar
@onready var mute_check_button: CheckButton = %MuteCheckButton

func _ready() -> void:
	GlobalVars.mute_toggled.connect(func (value): mute_check_button.button_pressed = value)
	difficulty_scroll_bar.set_value_no_signal(GlobalVars.difficulty)
	music_volume_scroll_bar.set_value_no_signal(GlobalVars.music_volume)
	sfx_volume_scroll_bar.set_value_no_signal(GlobalVars.sfx_volume)
	
	difficulty_value_label.text = str(GlobalVars.difficulty)
	music_volume_value_label.text = str(GlobalVars.music_volume)
	sfx_volume_value_label.text = str(GlobalVars.sfx_volume)
	
	mute_check_button.button_pressed = GlobalVars.is_muted

func _on_music_volume_scroll_bar_value_changed(value: float) -> void:
	GlobalVars.music_volume = int(value)
	sfx_volume_scroll_bar.text = str(GlobalVars.music_volume)


func _on_difficulty_scroll_bar_value_changed(value: float) -> void:
	GlobalVars.difficulty = int(value)
	difficulty_value_label.text = str(GlobalVars.difficulty)


func _on_sfx_volume_scroll_bar_value_changed(value: float) -> void:
	GlobalVars.sfx_volume = int(value)
	sfx_volume_value_label.text = str(GlobalVars.sfx_volume)


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_mute_check_button_toggled(toggled_on: bool) -> void:
	GlobalVars.is_muted = toggled_on
