extends Node2D

@onready var lb_state_machine = $LeftBumper/AnimationTree.get("parameters/playback")
@onready var lt_state_machine = $LeftTrigger/AnimationTree.get("parameters/playback")
@onready var rb_state_machine = $RightBumper/AnimationTree.get("parameters/playback")
@onready var rt_state_machine = $RightTrigger/AnimationTree.get("parameters/playback")
@onready var b_state_machine = $Buttons/AnimationTree.get("parameters/playback")

@onready var audio_stream = $Conductor

#00001 (1) = RT
#00010 (2) = RB
#00100 (4) = BUTTON
#01000 (8) = LB
#10000 (16) = LT
var song = []

var bpm = 120
var offset = 0.2
var crochet
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

func _ready():
	lastbeat = 0
	crochet = 60 / bpm
	$Conductor.play_with_beat_offset(8)

func _physics_process(_delta):
	button_animation("leftbumper", lb_state_machine)
	button_animation("lefttrigger", lt_state_machine)
	button_animation("rightbumper", rb_state_machine)
	button_animation("righttrigger", rt_state_machine)
	button_animation("button", b_state_machine)
	

func button_animation(button, state_machine):
	print(button)
	if(Input.get_action_strength(button) > 0 and state_machine.get_current_node() != "press"):
		state_machine.travel("press")
	else:
		state_machine.travel("unpress")
	

func _on_conductor_beat(position):
	print("beat")
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 162:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 322:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 396:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0


func _on_conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _spawn_notes(_to_spawn):
	print("foo")
	lane = randi() % 5
	instance = note.instantiate()
	instance.initialize(lane)
	add_child(instance)
	

