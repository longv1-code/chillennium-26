extends Control
# Timing QTE
@export var qte_duration: float = 1.5
@export var perfect_window: float = 0.15
var time_left: float
var active: bool = false
var target: Node = null
# Spam QTE
@export var spam_duration: float = 2.0
@export var fill_rate: float = 0.3      # how fast bar fills per second (increase = harder)
@export var drain_per_press: float = 0.15 # how much each space press drains (decrease = harder)
var spam_mode: bool = false
var spam_fill: float = 0.01  # 0.0 = empty (win), 1.0 = full (fail)
var perfect_time: float

signal qte_success(target)
signal qte_fail

func _ready():
	visible = false
	center_qte_container()
	# Setup SpamHeart
	var spam_heart = $QTEContainer/SpamHeart
	spam_heart.min_value = 0.0
	spam_heart.max_value = 1.0
	spam_heart.value = 0.0
	spam_heart.visible = false
# Centers QTEContainer on screen (Godot 4 safe)
func center_qte_container():
	var screen_size = get_viewport().get_visible_rect().size
	var container_size = $QTEContainer.get_size()
	$QTEContainer.position = screen_size / 2 - container_size / 2
func _align_approach_to_hit():
	var hit_circle = $QTEContainer/HitCircle
	var approach_circle = $QTEContainer/ApproachCircle
	approach_circle.pivot_offset = approach_circle.size / 2
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
	$QTEContainer/SpamHeart.visible = false
	var hit_circle = $QTEContainer/HitCircle
	var approach_circle = $QTEContainer/ApproachCircle
	approach_circle.scale = Vector2(2, 2)
	_align_approach_to_hit()
	var approach_radius = approach_circle.size.x / 2
	var hit_radius = hit_circle.size.x / 2
	var start_scale = (hit_radius / approach_radius) * 2.5
	approach_circle.scale = Vector2(start_scale, start_scale)
	_align_approach_to_hit()
	perfect_time = (hit_radius / approach_radius) * qte_duration / start_scale
	print("Start scale: ", start_scale, " | Perfect time: ", perfect_time)
# Start Spam QTE
func start_spam_qte(enemy: Node):
	if active:
		return
	stop_qte()
	target = enemy
	spam_fill = 0.0
	time_left = spam_duration
	spam_mode = true
	active = true
	visible = true
	var spam_heart = $QTEContainer/SpamHeart
	spam_heart.value = 0.0
	spam_heart.visible = true
	# Hide approach/hit circles during spam QTE — not needed
	$QTEContainer/HitCircle.visible = false
	$QTEContainer/ApproachCircle.visible = false
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
			print("qte_fail emitted")
		stop_qte()
		return
	if time_left <= 0:
		qte_fail.emit()
		print("qte_fail emitted")
		stop_qte()
# Spam QTE
func process_spam(delta):
	# Bar fills automatically over time
	spam_fill += fill_rate * delta
	spam_fill = clamp(spam_fill, 0.0, 1.0)
	# Each press drains the bar
	if Input.is_action_just_pressed("qte_action"):
		spam_fill -= drain_per_press
		spam_fill = clamp(spam_fill, 0.0, 1.0)
	$QTEContainer/SpamHeart.value = spam_fill
	# Win: drained to empty
	if spam_fill <= 0.0:
		qte_success.emit(target)
		stop_qte()
		return
	# Fail: filled completely
	if spam_fill >= 1.0:
		qte_fail.emit()
		print("qte_fail emitted")
		stop_qte()
		return
# Stop / Reset QTE
func stop_qte():
	active = false
	spam_mode = false
	visible = false
	target = null
	time_left = 0.0
	spam_fill = 0.0
	$QTEContainer/SpamHeart.visible = false
	$QTEContainer/HitCircle.visible = true
	$QTEContainer/ApproachCircle.visible = true
