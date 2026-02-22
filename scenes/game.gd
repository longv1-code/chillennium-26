extends Node2D

@onready var player = $Player
@onready var qte_ui = $UI/QTEUI
@onready var pause_menu = $UI/PauseMenu

func _ready():
	# player.qte_triggered.connect(func(enemy):
		# qte_ui.start_qte(enemy, mode=0) # 0 = timing, 1 = spam
	# )
	print("PauseMenu in tree? ", pause_menu.is_inside_tree())
	pause_menu.hide()  # ensure menu starts hidden
	qte_ui.qte_success.connect(_on_qte_success)
	qte_ui.qte_fail.connect(_on_qte_fail)

func _input(event):
	if event.is_action_pressed("escape"):
		print("Pause key pressed.")
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true

func _on_qte_success(enemy):
	print("QTE Success!")
	if enemy:
		enemy.queue_free()
	player.qte_active = false

func _on_qte_fail():
	print("QTE Failed!")
	player.qte_active = false
