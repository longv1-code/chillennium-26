extends CharacterBody2D

var speed: float = 600

var qte_active: bool = false
var qte_target: Node = null
var qte_time: float = 0.0
var qte_duration: float = 3.0 # seconds to react

var nearby_item: Node = null 

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = direction * speed
	move_and_slide()

signal qte_triggered(enemy)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not qte_active:
		qte_active = true
		qte_target = body
		emit_signal("qte_triggered", body)
	
func _on_interaction_area_body_entered(body: Node2D) -> void: # detects nearby items
	if body.is_ingroup("items"):
		nearby_item = body
		print("Item in range: ", body.name)

func take_damage():
	print("Player damaged")
