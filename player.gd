extends CharacterBody2D

@onready var health_ui = $UI/HealthUI

var speed: float = 6000
var nearby_item: Node = null 
var health = 3

var qte_active: bool = false
var qte_target: Node = null

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed * delta
	move_and_slide()
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("items"): # detects nearby items
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
	print("Player damaged")
	health -= 1
	health_ui.set_health(health)
signal qte_triggered(enemy)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not qte_active:
		qte_active = true
		qte_target = body
		emit_signal("qte_triggered", body)
