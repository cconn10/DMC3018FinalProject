extends Control

func _ready():
	pass
	
	
func _unhandled_input(event):
	if event.is_action_pressed("open_menu"):
		if $Control_Overlay.visible:
			$Control_Overlay.hide()
			$Tab_Overlay.show()
		else:
			$Control_Overlay.show()
			$Tab_Overlay.hide()
