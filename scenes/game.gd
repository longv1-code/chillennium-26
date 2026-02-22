extends Node2D

@onready var player = $Player
@onready var qte_ui = $UI/QTEUI
@onready var health_ui = $UI/HealthUI
@onready var sanity_bar = $UI/SanityBar
@onready var camera = $Player/Camera2D
@onready var lantern = $Player/PointLight2D

var maps = {
	1: preload("res://scenes/dungeon_tm.tscn"),
	2: preload("res://scenes/evil_tm.tscn"),
	3: preload("res://scenes/void_tm.tscn"),
	4: preload("res://scenes/void_tm.tscn")
}

var current_map: Node = null
var transitioning = false

var spawn_positions = {
	1: Vector2(-2002.0, -821.0),
	2: Vector2(1374.0, -27.0),
	3: Vector2(3315.0, -98.0), 
	4: Vector2(5296.0, 2020.0)
}

func _ready():
	player.qte_triggered.connect(qte_ui.start_qte)
	player.qte_spam_triggered.connect(qte_ui.start_spam_qte)
	qte_ui.qte_success.connect(_on_qte_success)
	qte_ui.qte_fail.connect(_on_qte_fail)
	sanity_bar.map_changed.connect(_on_map_changed)
	load_map(maps[1])
	player.global_position = spawn_positions[1]

func load_map(map_scene):
	if current_map:
		current_map.queue_free()
	current_map = map_scene.instantiate()
	add_child(current_map)
	move_child(current_map, 0)

#func _unhandled_input(event):
#	if event.is_action_pressed("enter"):
#		print("Transitioning...")
#		start_transition(2)

func _on_qte_success(enemy):
	print("QTE Success!")
	if enemy:
		enemy.queue_free()
	player.qte_active = false
	player.set_physics_process(true)

func _on_qte_fail():
	print("QTE Failed!")
	player.take_damage()
	player.qte_active = false
	player.set_physics_process(true)

func _on_map_changed(map_num: int):
	if map_num == 1:
		return # no transition for first stage
	start_transition(map_num)

func start_transition(map_num: int):
	if transitioning:
		return
	transitioning = true
	player.set_physics_process(false)
	lantern.flicker_active = false
	
	# face player south
	player.get_node("AnimatedSprite2D").play("move down")
	
	# kill organic flicker so it doesn't fight the transition tween
	if lantern.current_tween:
		lantern.current_tween.kill()
	lantern.flicker_active = false
	
	var flicker_tween = create_tween()
	for i in range(5):
		flicker_tween.tween_property(lantern, "energy", 0.1, 0.15)
		flicker_tween.tween_property(lantern, "energy", 1.0, 0.15)
	flicker_tween.tween_property(lantern, "energy", 0.1, 0.15)
	
	await flicker_tween.finished
	
	 # fade to black and transition
	var tween = create_tween()
	tween.tween_property(lantern, "energy", 0.0, 0.3)

	# swap map while dark
	tween.tween_callback(func():
		load_map(maps[map_num])
		player.global_position = spawn_positions[map_num]
	)

	tween.tween_interval(0.2)

	# sputter back to life
	tween.tween_property(lantern, "energy", 0.3, 0.05)
	tween.tween_property(lantern, "energy", 1.0, 0.1)
	tween.tween_property(lantern, "energy", 0.5, 0.05)
	tween.tween_property(lantern, "energy", 1.05, 0.3)

	# unlock movement and re-enable organic flicker
	tween.tween_callback(func():
		player.set_physics_process(true)
		lantern.flicker_active = true
		lantern.flicker()
		transitioning = false
	)
	
