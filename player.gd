extends CharacterBody2D

var speed: float = 600
var nearby_item: Node = null 
var health = 3

var qte_active: bool = false
var qte_target: Node = null

signal qte_triggered(enemy)

@onready var anim = $AnimatedSprite2D

#const FLOATING_TEXT = preload("res://floating_text.tscn") 	
# movement
func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	#animation
	if direction.x > 0:
		anim.play("move right")
	elif direction.x < 0:
		anim.play("move left")
	elif direction.y > 0:
		anim.play("move down")
	elif direction.y < 0:
		anim.play("move up")
	else:
		# Stops playing when you release the keys
		anim.stop()

# item interaction
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("items"): # detects nearby items
		nearby_item = body
		print("Item in range: ", body.name)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if nearby_item == body: # ensures item variable reset
		nearby_item = null
		print("Item left: ", body.name)

func _unhandled_input(event):
	if event.is_action_pressed("interact") and nearby_item: # interact with item
		print("Interacted with: ", nearby_item.name)
		
		#var text_instance = FLOATING_TEXT.instantiate()
		#text_instance.text = "wha da helly...." # You can change what it says here!
		#text_instance.global_position = nearby_item.global_position # Spawn it at the item
		#get_tree().current_scene.add_child(text_instance) # Add it to the game world
		
		nearby_item.queue_free()
		nearby_item = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not qte_active:
		qte_active = true
		qte_target = body
		qte_triggered.emit(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if body == qte_target and not qte_active:
		qte_target = null
		get_node("../CanvasLayer/Control").collect_fuel()
