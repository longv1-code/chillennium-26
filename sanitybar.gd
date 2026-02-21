extends Control

@onready var bar = $SanityBar

var timer := 400.0 # timer in seconds for sanity bar to ensure completion
var max_value := 100.0

# used to ensure stage occurs once
var triggered_stage_1 = false
var triggered_stage_2 = false
var triggered_stage_3 = false
var triggered_stage_4 = false

func _ready(): # sets the bar values first load
	bar.max_value = max_value
	bar.value = max_value
	
func _process(delta): # continously run
	drain_bar(delta)
	check_stages()
	
func drain_bar(delta): # handles drain system
	var drain = max_value / timer
	bar.value -= drain * delta

func check_stages(): # triggers stages
	var percent: float = (bar.value / max_value) * 100.0
	
	if percent <= 100 and not triggered_stage_1:
		triggered_stage_1 = true
		print("Stage 1 Started")
		stage_1()
	elif percent <= 70 and not triggered_stage_2:
		triggered_stage_2 = true
		print("Stage 2 Started")
		stage_2()
	elif percent <= 40 and not triggered_stage_3:
		triggered_stage_3 = true
		print("Stage 3 Started")
		stage_3()
	elif percent <= 15 and not triggered_stage_4:
		triggered_stage_4 = true
		print("Stage 4 Started")
		stage_4()

func stage_1():
	
func stage_2():
	
func stage_3():
	
func stage_4():
	
