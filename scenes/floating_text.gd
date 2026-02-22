extends Label

func _ready():
	# create_tween() is Godot's built-in tool for smooth, easy animations!
	var tween = create_tween()
	
	# Tell it to float UP 50 pixels over 1.0 second
	tween.tween_property(self, "position", position - Vector2(0, 50), 1.0)
	
	# At the exact same time (.parallel()), fade it out to invisible
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	
	# When the 1 second is up, delete the text so it doesn't lag the game
	tween.tween_callback(queue_free)
