extends Node2D

@onready var lb_state_machine = $"A Key"/AnimationTree.get("parameters/playback")
@onready var lt_state_machine = $"S Key"/AnimationTree.get("parameters/playback")
@onready var rb_state_machine = $"L Key"/AnimationTree.get("parameters/playback")
@onready var rt_state_machine = $"K Key"/AnimationTree.get("parameters/playback")
@onready var b_state_machine = $"Space"/AnimationTree.get("parameters/playback")
@onready var text_box = get_node("TextBox")

var total_score = 0
var best_combo = 0
var current_combo = 0

var score_threshold 

#00001 (1) = RB
#00010 (2) = RT
#00100 (4) = BUTTON
#01000 (8) = LT
#10000 (16) = LB
var drumTutorial = [
0,0,0,0,
1,0,0,0,
0,0,0,0,
1,0,0,0,
0,0,0,0,
16,0,0,0,
0,0,0,0,
16,0,0,0,
1,0,0,0,
1,0,0,0,
16,0,0,0,
16,0,0,0,
1,0,0,0,
16,0,0,0,
1,0,0,0,
16,0,0,0,
1,0,1,0,
1,0,1,0,
16,0,16,0,
16,0,16,0,
1,0,1,0,
1,0,1,0,
16,0,16,0,
16,0,16,0,
1,0,1,1,
0,1,1,0,
16,0,16,16,
0,16,16,0,
1,0,1,1,
0,17,17,0,
16,0,16,16,
0,17,17,0]
var tapTutorial = [
2,0,0,0,
2,0,0,0,
2,0,0,0,
2,0,0,0,
8,0,0,0,
8,0,0,0,
8,0,0,0,
8,0,0,0,
2,0,2,0,
2,0,2,0,
8,0,8,0,
8,0,8,0,
2,0,2,0,
8,0,8,0,
2,0,2,0,
8,0,8,0,
2,2,0,2,
0,2,0,2,
2,8,0,8,
0,8,0,8,
8,2,0,2,
0,2,0,2,
2,8,0,8,
0,8,0,8,
8,0,2,2,
0,8,0,8,
0,2,0,2,
0,8,0,8,
0,2,0,2,
0,8,0,8,
0,2,0,2,
0,8,8,0]
var shakeTutorial = [
0,0,0,0,
4,0,0,0,
0,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,0,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,0,
4,0,4,4,
0,4,0,4,
4,0,4,4,
0,4,0,4,
4,0,4,4,
0,4,0,4,
4,0,4,4,
0,4,0,4]
var finalTutorial = [
1,0,0,0,
16,0,0,0,
1,0,0,0,
1,0,0,0,
16,0,1,0,
16,0,1,0,
1,0,1,0,
16,0,0,0,
20,0,0,0,
5,0,0,0,
20,0,0,0,
5,0,0,0,
20,0,0,0,
20,0,0,0,
5,0,0,0,
5,0,0,0,
20,0,0,4,
20,0,0,4,
5,0,0,4,
5,0,0,4,
20,0,0,4,
20,0,0,4,
5,0,0,4,
5,0,0,4,
20,0,0,8,
20,0,0,2,
5,0,0,2,
5,0,0,8,
20,0,0,8,
20,0,0,2,
5,0,0,2,
5,0,0,2,
0,0,0,0,
16,20,0,24,
16,20,0,3,
1,5,0,3,
1,5,0,24,
16,20,0,24,
16,20,0,3,
]
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

var bpm = 180
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
	
	$Conductor.connect("finished", _on_conductor_finished)
	
	match GlobalVariables.current_song:
		GlobalVariables.SONG.DRUM_TUTORIAL:
			$Conductor.bpm = 180
			bpm = 180
			currentSong = drumTutorial
		GlobalVariables.SONG.SHAKE_TUTORIAL:
			$Conductor.bpm = 180
			bpm = 180
			currentSong = shakeTutorial
		GlobalVariables.SONG.TAP_TUTORIAL:
			$Conductor.bpm = 180
			bpm = 180
			currentSong = tapTutorial
		GlobalVariables.SONG.FINAL_TUTORIAL:
			$Conductor.bpm = 180
			bpm = 180
			currentSong = finalTutorial
		GlobalVariables.SONG.BOSS_BATTLE:
			$Conductor.bpm = 120
			bpm = 120
			currentSong = finalSong
			
	text_box.queue_text("Press Enter to Start Level...")

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
	if position < len(currentSong):
		_spawn_notes(currentSong[position])
		
	
func _on_conductor_finished():
	score_threshold = get_score_threshold()
	if(total_score > score_threshold):
		GlobalVariables.tutorials_completed.push_back(GlobalVariables.current_song)
		match len(GlobalVariables.tutorials_completed):
			1:
				GlobalVariables.overworld_music_path = "res://Music/Overworld_Without_Ukelele.mp3"
				GlobalVariables.overworld_music_volume = -25
			2:
				GlobalVariables.overworld_music_volume = -20
			3:
				GlobalVariables.overworld_music_volume = -15
			4:
				GlobalVariables.overworld_music_volume = -10
			5:
				GlobalVariables.overworld_music_volume = 0
				GlobalVariables.overworld_music_path = "res://Music/Overworld_With_Ukelele.mp3"
				
		text_box.queue_text("You've completed the song!")
	else:
		text_box.queue_text("You needed " + str(score_threshold) + " points to pass... Try again.")
	
	

func _on_conductor_measure(position):
	pass
	
func get_score_threshold():
	var beats = currentSong.filter(func(beat): return beat != 0).size()
	return (beats * 200) * 0.75

func _spawn_notes(to_spawn):
	while to_spawn > 0:
		if to_spawn - 16 >= 0:
			lane = 0
			to_spawn -= 16
		elif to_spawn - 8 >= 0:
			lane = 1
			to_spawn -= 8
		elif to_spawn - 4 >= 0:
			lane = 2
			to_spawn -= 4
		elif to_spawn - 2 >= 0:
			lane = 3
			to_spawn -= 2
		elif to_spawn - 1 >= 0:
			lane = 4
			to_spawn -= 1
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
		
func increment_score(score):
	if score > 0:
		current_combo += 1
	else:
		current_combo = 0
		
	if current_combo > best_combo:
		best_combo = current_combo
		
	total_score += score
	
	$Score.text = "Score: " + str(total_score)
	$BestCombo.text = "Best Combo: " + str(best_combo)
	$CurrentCombo.text = "Current Combo: " + str(current_combo)
		
func _unhandled_input(event):
	if event.is_action_pressed("Force_quit"):
		
		GlobalVariables.goto_scene(GlobalVariables.previous_scene)


func _on_text_box_text_finished():
	if song_position_in_beats > 0:
		GlobalVariables.goto_scene(GlobalVariables.previous_scene)
	else:
		$Conductor.play_with_beat_offset(6)


func _on_text_box_force_quit():
	GlobalVariables.goto_scene(GlobalVariables.previous_scene)
