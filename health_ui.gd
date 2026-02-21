extends Control

var max_health: int =  3
var current_health: int = 3

@onready var hearts = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]

func _ready():
	update_hearts() # initialize hearts
	
func set_hearts(value: int): # sets amount of hearts
	current_health = clamp(value, 0, max_health)
	update_hearts()

# Called when Player health changes
func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	update_hearts()

func update_hearts() -> void:
	for i in range(max_health):
		hearts[i].visible = i < current_health
