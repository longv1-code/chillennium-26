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
	
func update_hearts(): # makes current hearts visible
	for i in range(max_health):
		hearts[i].visible = i < current_health
