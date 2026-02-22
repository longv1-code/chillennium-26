extends Node2D

@onready var player = $Player
@onready var health_ui = $UI/HealthUI

func _ready():
	player.health_changed.connect(health_ui.set_health)
