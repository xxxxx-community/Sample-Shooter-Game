extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu/settings_menu.tscn")
