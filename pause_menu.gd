extends Control

# Start hidden
func _ready():
	hide()
	# Ensure the PauseMenu processes input even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

# Resume button pressed
func on_resume_pressed():
	get_tree().paused = false
	hide()

# Quit button pressed
func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")
