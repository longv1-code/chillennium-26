extends Control

@onready var bar = $SanityBar
#var g_delta = 

var timer := 400.0 # timer in seconds for sanity bar to ensure completion
const stage_1_max_value = 100
const stage_2_max_value = 70
const stage_3_max_value = 40
const stage_4_max_value = 10
var max_value = 100

const base_dec_rate := .5
const dec_rate_increase := 5
var curr_drain_mult := 1 

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
	
func _process(delta): # continously run
	check_stages()
	drain_bar(delta)
	
func drain_bar(delta): # handles drain system
	var total_drain = base_dec_rate * curr_drain_mult
	bar.value -= total_drain * delta
	
func collect_fuel():
	bar.value = min(bar.value + refill_amt, max_value)
	
	curr_drain_mult += dec_rate_increase
	print("Refilled! New drain multiplier: ", curr_drain_mult)

func check_stages(): # triggers stages
	var percent: float = (bar.value / max_value) * 100.0
	
	if percent <= stage_1_max_value and not triggered_stage_1:
		triggered_stage_1 = true
		curr_drain_mult = 1
		#curr_state = 1
		print("Stage 1 Started")
	elif percent <= stage_2_max_value and not triggered_stage_2:
		triggered_stage_2 = true
		max_value = stage_2_max_value
		curr_drain_mult = 3
		#curr_state = 2
		print("Stage 2 Started")
	elif percent <= stage_3_max_value and not triggered_stage_3:
		triggered_stage_3 = true
		max_value = stage_3_max_value
		curr_drain_mult = 3
		#curr_state = 3
		print("Stage 3 Started")
	elif percent <= stage_4_max_value and not triggered_stage_4:
		triggered_stage_4
		max_value = stage_4_max_value
		curr_drain_mult = 1
		#curr_state = 4
		print("Stage 4 Started")		

func stage_1():
	print("stage 1")
func stage_2():
	print("stage 2")
func stage_3():
	print("print 3")
func stage_4():
	print("4")
	
#func _input(event):
	## Check if a key was pressed, specifically the 'F' key
	#if event is InputEventKey and event.keycode == KEY_F and event.pressed:
		## not event.is_echo() prevents it from rapid-firing if you hold the key down
		#if not event.is_echo(): 
			#collect_fuel()
