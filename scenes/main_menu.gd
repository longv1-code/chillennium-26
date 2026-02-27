extends Control

@onready var start_button = $StartButton
@onready var credit_button = $CreditButton
@onready var hover_sfx = $AudioStreamPlayer

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	credit_button.pressed.connect(_on_credit_pressed)
	start_button.focus_entered.connect(_on_any_button_focused)
	credit_button.focus_entered.connect(_on_any_button_focused)
	
func _on_any_button_focused():
	hover_sfx.play()

func _on_start_pressed():
	print("Start Game clicked.")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_credit_pressed():
	print("Credits clicked.")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
