extends Sprite2D

var in_target = false
var current_note = null

@export var input = ""

#func _unhandled_input(event):
#	print(event)
#	if event.is_action(input):
#		if event.is_action_pressed(input, false):
#			if current_note != null:
#				if in_target:
#					current_note.destroy()
#				_reset()
				
func _on_area_entered(area):
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
