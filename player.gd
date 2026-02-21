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


func _process(delta):
	# quick time event
	if qte_active:
		qte_time -= delta
		
		if Input.is_action_just_pressed("qte_action") and qte_target: # handles killing enemies
			print("Enemy killed.")
			qte_target.queue_free()
			qte_active = false
			qte_target = null
		
		if qte_time <= 0: # failed qte
			print("QTE failed.")
			qte_active = false
			qte_target = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not qte_active: # checks enemy in area
		print("Enemy detected.")
		qte_active = true
		qte_target = body
		qte_time = qte_duration
		print("QTE triggered.")
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_ingroup("items"): # detects nearby items
		nearby_item = body
		print("Item in range: ", body.name)
