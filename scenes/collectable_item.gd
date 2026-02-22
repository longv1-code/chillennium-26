extends StaticBody2D

# These appear in the Inspector!
@export var item_name: String = "default_item"
@export var item_texture: Texture2D

@onready var sprite = $Sprite2D

func _ready():
	# Automatically update the sprite to whatever you dragged into the Inspector
	if item_texture != null:
		sprite.texture = item_texture
