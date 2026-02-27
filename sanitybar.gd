extends Control

@onready var bar = $SanityBar
@onready var music_player_1 = AudioStreamPlayer.new()
@onready var music_player_2 = AudioStreamPlayer.new()
var active_player: AudioStreamPlayer

var music_stage_1 = preload("res://sound/stage1_bgmusic.mp3")
var music_stage_2 = preload("res://sound/stage2_bgmusic.mp3")
var music_stage_3 = preload("res://sound/stage3_bgmusic.mp3")

# signal map changes
signal map_changed(map_num)

# load housing
var h1_tex_1 = preload("res://sanity_bar_stages/sanitybar_1b.png")
var h2_tex_1 = preload("res://sanity_bar_stages/sanitybar_1f.png")
var h1_tex_2 = preload("res://sanity_bar_stages/sanitybar_2b.png")
var h2_tex_2 = preload("res://sanity_bar_stages/sanitybar_2f.png")
var h1_tex_3 = preload("res://sanity_bar_stages/sanitybar_3b.png")
var h2_tex_3 = preload("res://sanity_bar_stages/sanitybar_3f.png")
var h1_tex_4 = preload("res://sanity_bar_stages/sanitybar_4b.png")
var h2_tex_4 = preload("res://sanity_bar_stages/sanitybar_4f.png")
#var g_delta = 

var timer := 400.0 # timer in seconds for sanity bar to ensure completion
const stage_1_max_value = 100
const stage_2_max_value = 70
const stage_3_max_value = 40
const stage_4_max_value = 10
var max_value = 100

var base_dec_rate := 0.5
const dec_rate_increase := .5
var curr_drain_mult :float= 1.0

const refill_amt := 2

# used to ensure stage occurs once
#var curr_state = 1

var triggered_stage_1 = false 
var triggered_stage_2 = false
var triggered_stage_3 = false
var triggered_stage_4 = false

func _ready(): # sets the bar values first load
	bar.max_value = max_value
	bar.value = max_value
	bar.min_value = 0.0
	base_dec_rate = max_value / timer
	
	add_child(music_player_1)
	add_child(music_player_2)
	active_player = music_player_1
	
func _process(delta): # continously run
	check_stages()
	drain_bar(delta)
	
func drain_bar(delta): # handles drain system
	var total_drain: float = base_dec_rate * curr_drain_mult
	bar.value -= total_drain * delta
	
func transition_music(new_stream: AudioStream):
	# Determine which player is currently silent
	var next_player = music_player_2 if active_player == music_player_1 else music_player_1
	
	# Prepare the next song
	next_player.stream = new_stream
	next_player.volume_db = -80 # Start silent
	next_player.play()
	
	# Create the tween for cross-fade
	var tween = create_tween().set_parallel(true)
	
	# Fade OUT current music
	tween.tween_property(active_player, "volume_db", -80, 2.0)

	# Fade IN new music
	tween.tween_property(next_player, "volume_db", 0, 4.0)
	
	# Cleanup: Stop the old player once the fade is done
	tween.chain().tween_callback(active_player.stop)
	
	# Swap the active player reference
	active_player = next_player

func collect_fuel():
	bar.value = min(bar.value + refill_amt, max_value)
	
	curr_drain_mult += dec_rate_increase
	print("Refilled! New drain multiplier: ", curr_drain_mult)

func check_stages(): # triggers stages
	var percent: float = (bar.value / max_value) * 100.0

	if percent <= stage_1_max_value and not triggered_stage_1:
		triggered_stage_1 = true
		curr_drain_mult = 1
		bar.texture_under = h1_tex_1
		bar.texture_over = h2_tex_1
		print("Stage 1 Started")
	elif percent <= stage_2_max_value and not triggered_stage_2:
		triggered_stage_2 = true
		curr_drain_mult = 1
		bar.texture_under = h1_tex_2
		bar.texture_over = h2_tex_2
		map_changed.emit(2)
		print("Stage 2 Started")
	elif percent <= stage_3_max_value and not triggered_stage_3:
		triggered_stage_3 = true
		curr_drain_mult = 1
		bar.texture_under = h1_tex_3
		bar.texture_over = h2_tex_3
		map_changed.emit(3)
		print("Stage 3 Started")
	elif percent <= stage_4_max_value and not triggered_stage_4:
		triggered_stage_4 = true
		curr_drain_mult = 1
		bar.texture_under = h1_tex_4
		bar.texture_over = h2_tex_4
		map_changed.emit(4)
		print("Stage 4 Started")
