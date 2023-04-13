extends AudioStreamPlayer

@export var bpm = 180
@export var measures = 4

var song_position = 0.0
var song_position_in_beats = 1
var last_reported_beat = 0
var offset = 0
var current_measure = 1
var crotchet

signal beat(position)
signal measure(position)

func _ready():
	crotchet = 60.0 / bpm
	self.stream = load(GlobalVariables.current_song_path)

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix() 
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / crotchet)) + offset
		_report_beat()
		
func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if current_measure > measures:
			current_measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", current_measure)
		last_reported_beat = song_position_in_beats
		current_measure += 1
		
func play_from_beat(beat, off):
	play()
	seek(beat * crotchet)
	offset = off
	current_measure = beat % measures

func play_with_beat_offset(num):
	offset = num
	$StartTimer.wait_time = 60.0 / bpm
	$StartTimer.start()

func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < offset - 1:
		$StartTimer.start()
	elif song_position_in_beats == offset - 1:
		$StartTimer.wait_time -= (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
