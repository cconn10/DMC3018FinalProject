extends Sprite2D

var input_options = ["leftbumper", "lefttrigger", "button", "righttrigger", "rightbumper"]

var lane_0_pos = 408;
var lane_1_pos = 440;
var lane_2_pos = 472;
var lane_3_pos = 504;
var lane_4_pos = 536;

var y_limit = 408;

var perfect = false
var good = false
var okay = false

var current_note = null
var lane = -1

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
		if lane == l:
			print("LANE SET")
			if perfect:
				current_note.destroy()
				get_parent().increment_score(300)
			elif good:
				current_note.destroy()
				get_parent().increment_score(200)
			elif okay:
				current_note.destroy()
				get_parent().increment_score(100)
			else:
				get_parent().increment_score(0)
			_reset()


func check_lane(area):
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

func _reset():
	current_note = null
	lane = -1
	okay = false
	good = false
	perfect = false


func _on_okay_area_entered(area):
	current_note = area
	check_lane(area)
	if area.is_in_group("note"):
		okay = true

func _on_okay_area_exited(area):
	if area.is_in_group("note"):
		okay = false
		get_parent().increment_score(0)
	
func _on_good_area_entered(area):
	if area.is_in_group("note"):
		good = true


func _on_good_area_exited(area):
	if area.is_in_group("note"):
		good = false


func _on_perfect_area_entered(area):
	if area.is_in_group("note"):
		perfect = true
	

func _on_perfect_area_exited(area):
	if area.is_in_group("note"):
		perfect = false
