extends Control

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
