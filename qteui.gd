extends Control

# time space once
@export var qte_duration: float = 1.5
@export var perfect_window: float = 0.15

var time_left: float
var active: bool = false
var target: Node = null

# spamming space
@export var spam_required: int = 15
@export var spam_duration: float = 2.0

var spam_count: int = 0
var spam_mode: bool = false

signal qte_success(target)
signal qte_fail

func _ready():
	randomize()
	visible = false

func start_qte(enemy):
	target = enemy
	time_left = qte_duration
	active = true
	visible = true

	randomize_position()
	
	$QTEContainer/ApproachCircle.scale = Vector2(2, 2)

func start_spam_qte(enemy):
	target = enemy
	spam_count = 0
	time_left = spam_duration
	spam_mode = true
	active = true
	visible = true

func _process(delta):
	if not active:
		return
	
	if spam_mode:
		process_spam(delta)
	else:
		process_timing(delta)

func process_timing(delta):
	time_left -= delta
	
	var ratio = time_left / qte_duration
	$QTEContainer/ApproachCircle.scale = Vector2(2, 2) * ratio
	
	if Input.is_action_just_pressed("qte_action"):
		if abs(time_left) <= perfect_window:
			qte_success.emit(target)
		else:
			qte_fail.emit()
		stop_qte()
	
	if time_left <= 0:
		qte_fail.emit()
		stop_qte()
		
func process_spam(delta):
	time_left -= delta
	
	if Input.is_action_just_pressed("qte_action"):
		spam_count += 1
	
	if spam_count >= spam_required:
		qte_success.emit(target)
		stop_qte()
	
	if time_left <= 0:
		qte_fail.emit()
		stop_qte()

func stop_qte():
	active = false
	visible = false
	target = null

func randomize_position():
	var screen_size = get_viewport_rect().size
	
	var center = screen_size / 2
	
	var range_x = 200
	var range_y = 150
	
	var random_offset = Vector2(
		randf_range(-range_x, range_x),
		randf_range(-range_y, range_y)
	)
	
	$QTEContainer.position = center + random_offset - ($QTEContainer.size / 2)
	
