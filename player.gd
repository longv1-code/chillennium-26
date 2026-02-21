extends CharacterBody2D

@onready var health_ui = get_tree().current_scene.get_node("UI/HealthUI")

var speed: float = 600
var nearby_item: Node = null 
var health = 3

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

func take_damage(): # take 1 damage from monster
	health -= 1
	health_ui.set_health(health)
