extends Sprite2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _physics_process(_delta):
	if(Input.get_action_strength("leftbumper") > 0 and state_machine.get_current_node() != "press"):
		state_machine.travel("press")
	else:
		state_machine.travel("unpress")
	
