extends Node

func _ready():
	$game_level.connect("to_rhythm", _on_to_rhythm)

func _on_to_rhythm(song_name):
	var rhythm_level
	print("foo")
	rhythm_level = load("res://Levels/rhythm_level.tscn").instance()
	add_child(rhythm_level)
	$game_level.queue_free()
