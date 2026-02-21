extends CharacterBody2D

var speed: float = 600

var nearby_item: Node = null 

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = direction * speed
	move_and_slide()
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_ingroup("items"): # detects nearby items
		nearby_item = body
		print("Item in range: ", body.name)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if nearby_item == body: # ensures item variable reset
		nearby_item = null
		print("Item left: ", body.name)

func _input(event):
	if event.is_action_pressed("interact") and nearby_item: # interact with item
		print("Interacted with: ", nearby_item.name)
		nearby_item.queue_free()
		nearby_item = null
