extends PointLight2D

@export var base_energy: float = 1.05
@export var flicker_strength: float = 0.15
@export var flicker_speed_min: float = 0.05
@export var flicker_speed_max: float = 0.15
var flicker_active: bool = true  # renamed from enabled
var current_tween: Tween = null

func _ready():
	flicker()

func flicker():
	if not flicker_active:
		await get_tree().create_timer(0.1).timeout
		flicker()
		return
	current_tween = create_tween()
	var target = base_energy + randf_range(-flicker_strength, flicker_strength)
	var duration = randf_range(flicker_speed_min, flicker_speed_max)
	current_tween.tween_property(self, "energy", target, duration)
	current_tween.tween_callback(flicker)
