extends Sprite2D

var input_options = ["leftbumper", "lefttrigger", "button", "righttrigger", "rightbumper"]

var in_target = false
var current_note = null

@export var input = "leftbumper"

func _unhandled_input(event):
	if event.is_action(input):
		if event.is_action_pressed(input):
			if current_note != null:
				if in_target:
					print("event")
					current_note.destroy()
				_reset()

func _on_area_entered(area):
	print(area.is_in_group("note"))
	if area.is_in_group("note"):
		in_target = true
		print(in_target)
		current_note = area
		
func _on_area_exited(area):
	if area.is_in_group("note"):
		in_target = false
		current_note = null

func _reset():
	current_note = null
	in_target = false
