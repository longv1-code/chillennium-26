extends Control

@onready var start_button = $StartButton
@onready var credit_button = $CreditButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	credit_button.pressed.connect(_on_credit_pressed)
	
func _on_start_pressed():
	print("Start Game clicked.")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_credit_pressed():
	print("Credits clicked.")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
