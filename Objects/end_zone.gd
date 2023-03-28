extends Sprite2D

var input_options = ["leftbumper", "lefttrigger", "button", "righttrigger", "rightbumper"]

var lane_0_pos = 408;
var lane_1_pos = 440;
var lane_2_pos = 472;
var lane_3_pos = 504;
var lane_4_pos = 536;

var in_target = false
var current_note = null
var lane = -1

@export var input = "leftbumper"

func _unhandled_input(event):
	if event.is_action_pressed("leftbumper"):
		target_check(0)
	elif event.is_action_pressed("lefttrigger"):
		target_check(1)
	elif event.is_action_pressed("button"):
		target_check(2)
	elif event.is_action_pressed("righttrigger"):
		target_check(3)
	elif event.is_action_pressed("rightbumper"):
		target_check(4)
			
func target_check(l):
	if current_note != null:
		if in_target and lane == l:
			current_note.destroy()
			_reset()
	

func _on_area_entered(area):
	var x_pos = area.position.x
	if(x_pos == lane_0_pos):
		lane = 0
	elif(x_pos == lane_1_pos):
		lane = 1
	elif(x_pos == lane_2_pos):
		lane = 2
	elif(x_pos == lane_3_pos):
		lane = 3
	elif(x_pos == lane_4_pos):
		lane = 4
	if area.is_in_group("note"):
		in_target = true
		current_note = area
		
func _on_area_exited(area):
	if area.is_in_group("note"):
		in_target = false
		current_note = null

func _reset():
	current_note = null
	in_target = false
