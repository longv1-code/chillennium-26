extends CharacterBody2D

enum State {LUNGE, LATCHED}

@export var lunge_speed: float = 1500.0
@export var qte_type: String = "timing"
@export var lunge_texture: Texture2D
@export var latched_texture: Texture2D

var state = State.LUNGE
var player: Node = null
var lunge_direction: Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = lunge_texture
	
func _physics_process(delta: float) -> void:
	match state:
		State.LUNGE:
			if player:
				lunge_direction = (player.global_position - global_position).normalized()
				velocity = lunge_direction * lunge_speed
				move_and_slide()
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if collision.get_collider() == player:
					latch_on()
						
		State.LATCHED:
			if is_instance_valid(player):
				global_position = player.global_position

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state == State.LUNGE:
		player = body
		lunge_direction = (player.global_position - global_position).normalized()
		sprite.texture = lunge_texture

func latch_on():
	state = State.LATCHED
	sprite.texture = latched_texture
	velocity = Vector2.ZERO
	if player.has_method("on_enemy_latched"):
		player.set_physics_process(false)
		player.get_node("AnimatedSprite2D").hide()
		player.on_enemy_latched(self, qte_type)
