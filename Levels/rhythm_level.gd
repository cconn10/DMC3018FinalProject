extends Node2D

@onready var lb_state_machine = $LeftBumper/AnimationTree.get("parameters/playback")
@onready var lt_state_machine = $LeftTrigger/AnimationTree.get("parameters/playback")
@onready var rb_state_machine = $RightBumper/AnimationTree.get("parameters/playback")
@onready var rt_state_machine = $RightTrigger/AnimationTree.get("parameters/playback")
@onready var b_state_machine = $Buttons/AnimationTree.get("parameters/playback")

#00001 (1) = RB
#00010 (2) = RT
#00100 (4) = BUTTON
#01000 (8) = LT
#10000 (16) = LB
var drumTutorial = [
0,0,0,1,
0,0,0,1,
0,0,0,1,
0,0,0,1,
0,1,0,1,
0,1,0,1,
0,1,0,1,
0,1,0,1,
1,1,1,1,
1,1,1,1,
1,1,1,1,
1,1,1,1]
var tapTutorial = []
var shakeTutorial = []
var finalTutorial = []
var finalSong = [
0,0,0,0,
0,0,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,4,4,
4,4,4,4,
4,4,4,4,
4,4,4,4,
4,4,1,1,
16,16,1,16,
16,1,16,16,
16,1,16,16,
1,1,2,2,
8,8,2,2,
8,8,2,2,
8,8,2,2,
8,8,2,8,
2,8,4,4,
4,4,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2,8,
2,8,2
]

var bpm = 120
var offset = 0.2
var crotchet
var lastbeat
var songposition
var song_position_in_beats = 0

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 0
var spawn_4_beat = 0

var rand = 0
var lane = 0
var note = load("res://Objects/note.tscn")
var instance
var currentSong

func _ready():
	lastbeat = 0
	crotchet = 60 / bpm
	$Conductor.play_with_beat_offset(2)

func _physics_process(_delta):
	button_animation("leftbumper", lb_state_machine)
	button_animation("lefttrigger", lt_state_machine)
	button_animation("rightbumper", rb_state_machine)
	button_animation("righttrigger", rt_state_machine)
	button_animation("button", b_state_machine)
	

func button_animation(button, state_machine):
	if(Input.get_action_strength(button) > 0 and state_machine.get_current_node() != "press"):
		state_machine.travel("press")
	else:
		state_machine.travel("unpress")

func _on_conductor_beat(position):
	song_position_in_beats = position
	print(position)
	if position < len(finalSong):
		_spawn_notes(finalSong[position])
	

func _on_conductor_measure(position):
	pass
#	if position == 1:
#		_spawn_notes(spawn_1_beat)
#	elif position == 2:
#		_spawn_notes(spawn_2_beat)
#	elif position == 3:
#		_spawn_notes(spawn_3_beat)
#	elif position == 4:
#		_spawn_notes(spawn_4_beat)

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		if to_spawn == 1:
			lane = 4
		elif to_spawn == 2:
			lane = 3
		elif to_spawn == 4:
			lane = 2
		elif to_spawn == 8:
			lane = 1
		elif to_spawn == 16:
			lane = 0
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
		
