extends Label


func _ready():
	# Create a new tween animation bound to this text node
	var tween = create_tween()
	
	# 1. Animate the 'position' moving UP by 50 pixels over 1.0 second
	tween.tween_property(self, "position", position - Vector2(0, 50), 1.0)
	
	# 2. Run this next animation AT THE SAME TIME (parallel)
	# Animate 'modulate:a' (the alpha/transparency) down to 0 over 1.0 second
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	
	# 3. When the animation is completely finished, delete the text node
	tween.tween_callback(queue_free)
