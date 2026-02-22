extends Node2D

@onready var qte_ui = $QTEUI
@onready var test_enemy = $TestEnemy

func _ready():
	qte_ui.qte_success.connect(_on_qte_success)
	qte_ui.qte_fail.connect(_on_qte_fail)

func _input(event):
	if event.is_action_pressed("qte_action"):
		print("Pressed space for testing!")

# optional Button signal:
func _on_test_button_pressed() -> void:
	print("Starting Timing QTE")
	qte_ui.start_qte(test_enemy)

func _on_qte_success(enemy):
	print("QTE Success! Target:", enemy.name)
	
func _on_qte_fail():
	print("QTE Failed!")
