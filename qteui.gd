extends Control

# Timing QTE
@export var qte_duration: float = 1.5
@export var perfect_window: float = 0.15

var time_left: float
var active: bool = false
var target: Node = null

# Spam QTE
@export var spam_required: int = 15
@export var spam_duration: float = 2.0

var spam_count: int = 0
var spam_mode: bool = false

var perfect_time: float

signal qte_success(target)
signal qte_fail

func _ready():
	visible = false
	center_qte_container()

# Centers QTEContainer on screen (Godot 4 safe)
func center_qte_container():
	var screen_size = get_viewport().get_visible_rect().size
	var container_size = $QTEContainer.get_size() # works on Control nodes in Godot 4
	$QTEContainer.position = screen_size / 2 - container_size / 2

func _align_approach_to_hit():
	var hit_circle = $QTEContainer/HitCircle
	var approach_circle = $QTEContainer/ApproachCircle

	# Pivot from center so scaling doesn't shift position
	approach_circle.pivot_offset = approach_circle.size / 2

	# Calculate centers and align
	var hit_center = hit_circle.position + hit_circle.size / 2
	approach_circle.position = hit_center - approach_circle.size / 2

# Start Timing QTE
func start_qte(enemy: Node):
	if active:
		return
	stop_qte()
	target = enemy
	time_left = qte_duration
	active = true
	spam_mode = false
	visible = true

	var hit_circle = $QTEContainer/HitCircle
	var approach_circle = $QTEContainer/ApproachCircle

	# reset scale
	approach_circle.scale = Vector2(2, 2)

	# center approach circle
	_align_approach_to_hit()

	# calculate perfect timing in seconds
	var approach_radius = approach_circle.size.x / 2
	var hit_radius = hit_circle.size.x / 2

	# Ensure approach circle always starts visually outside the hit circle
	var start_scale = (hit_radius / approach_radius) * 2.5  # 2.5 gives a comfortable starting gap
	approach_circle.scale = Vector2(start_scale, start_scale)
	_align_approach_to_hit()

	# Recalculate perfect_time with the dynamic start scale
	perfect_time = (hit_radius / approach_radius) * qte_duration / start_scale
	print("Start scale: ", start_scale, " | Perfect time: ", perfect_time)
	
# Start Spam QTE
func start_spam_qte(enemy: Node):
	if active:
		return
	stop_qte()
	target = enemy
	spam_count = 0
	time_left = spam_duration
	spam_mode = true
	active = true
	visible = true
	
	$QTEContainer/ApproachCircle.scale = Vector2(2, 2)
	_align_approach_to_hit()

# Process QTE
func _process(delta):
	if not active:
		return
	
	if spam_mode:
		process_spam(delta)
	else:
		process_timing(delta)

# Timing QTE
func process_timing(delta):
	time_left -= delta
	var ratio = time_left / qte_duration
	$QTEContainer/ApproachCircle.scale = Vector2(2, 2) * ratio
	
	if Input.is_action_just_pressed("qte_action"):
		if abs(time_left - perfect_time) <= perfect_window:
			qte_success.emit(target)
		else:
			qte_fail.emit()
		stop_qte()
		return
	
	if time_left <= 0:
		qte_fail.emit()
		stop_qte()

# Spam QTE
func process_spam(delta):
	time_left -= delta
	
	if Input.is_action_just_pressed("qte_action"):
		spam_count += 1
	
	if spam_count >= spam_required:
		qte_success.emit(target)
		stop_qte()
		return
	
	if time_left <= 0:
		qte_fail.emit()
		stop_qte()

# Stop / Reset QTE
func stop_qte():
	active = false
	spam_mode = false
	visible = false
	target = null
	time_left = 0.0
	spam_count = 0
