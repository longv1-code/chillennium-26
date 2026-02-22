extends Node2D

@onready var player = $Player
@onready var qte_ui = $UI/QTEUI
@onready var health_ui = $UI/health_ui

func _ready():
	player.qte_triggered.connect(qte_ui.start_qte)
	qte_ui.qte_success.connect(_on_qte_success)
	qte_ui.qte_fail.connect(_on_qte_fail)

func _on_qte_success(enemy):
	print("QTE Success!")
	if enemy:
		enemy.queue_free()
	player.qte_active = false

func _on_qte_fail():
	print("QTE Failed!")
	player.qte_active = false
