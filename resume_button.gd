extends Button

func _on_resumebutton_pressed():
	get_tree().paused = false
	hide()
