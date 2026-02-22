extends Control

# Timing QTE
@export var qte_duration: float = 1.5
@export var perfect_window: float = 0.15
var time_left: float
var active: bool = false
var target: Node = null

# Spam QTE
@export var spam_duration: float = 2.0
@export var fill_rate: float = 0.3
@export var drain_per_press: float = 0.15
var spam_mode: bool = false
var spam_fill: float = 0.0
var perfect_time: float

signal qte_success(target)
signal qte_fail

@onready var qte_container = $QTEContainer
@onready var hit_heart = $QTEContainer/HitHeart
@onready var approach_heart = $QTEContainer/ApproachHeart
@onready var spam_heart = $QTEContainer/SpamBar
@onready var spam_bar = $QTEContainer/SpamBar/SpamHeart

func _ready():
	visible = false
	center_qte_container()
	spam_bar.min_value = 0.0
	spam_bar.max_value = 1.0
	spam_bar.value = 0.0
	spam_heart.visible = false

func center_qte_container():
	var screen_size = get_viewport().get_visible_rect().size
	var container_size = qte_container.get_size()
	qte_container.position = screen_size / 2 - container_size / 2

func _align_approach_to_hit():
	approach_heart.pivot_offset = approach_heart.size / 2
	var hit_center = hit_heart.position + hit_heart.size / 2
	approach_heart.position = hit_center - approach_heart.size / 2

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
	spam_heart.visible = false
	hit_heart.visible = true
	approach_heart.visible = true
	_align_approach_to_hit()
	perfect_time = (hit_heart.size.x / (approach_heart.size.x * 2.0)) * qte_duration
	print("Perfect time: ", perfect_time)

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
	spam_bar.value = 0.0
	spam_heart.visible = true
	hit_heart.visible = false
	approach_heart.visible = false

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
	approach_heart.scale = Vector2(2, 2) * ratio
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
	spam_fill += fill_rate * delta
	spam_fill = clamp(spam_fill, 0.0, 1.0)
	if Input.is_action_just_pressed("qte_action"):
		spam_fill -= drain_per_press
		spam_fill = clamp(spam_fill, 0.0, 1.0)
	spam_bar.value = spam_fill
	if spam_fill <= 0.0:
		qte_success.emit(target)
		stop_qte()
		return
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
	spam_bar.value = 0.0
	spam_heart.visible = false
	hit_heart.visible = true
	approach_heart.visible = true
