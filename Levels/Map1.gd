extends Node2D

@onready var player = get_node("Spren")
@onready var drumPiece = get_node("BrokenDrum")
@onready var text_box = get_node("TextBox")

@export var DISTANCE_FROM_NPC = 100

var playerPos
var drumPiecePos

var entering_rhythm = false

func _ready():
	player.position.x = GlobalVariables.player_position[0]
	player.position.y = GlobalVariables.player_position[1]
	
	if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.TAP_TUTORIAL):
		$StaticBody2D/DrumCollision.disabled = true
		drumPiece.hide()
	
	var stream = $AudioStreamPlayer
	if FileAccess.file_exists((GlobalVariables.overworld_music_path)):
		var sfx = load(GlobalVariables.overworld_music_path)
		stream.stream = sfx
		stream.volume_db = GlobalVariables.overworld_music_volume
		stream.play()
	
	
func _process(delta):
	playerPos = player.position
	drumPiecePos = drumPiece.position
	print(playerPos.y > 270)
	if playerPos.y > 270:
		GlobalVariables.player_position = [-400, -240]
		GlobalVariables.goto_scene("res://Levels/Map2.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("button"):
		if abs(playerPos.x - drumPiecePos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - drumPiecePos.y) < DISTANCE_FROM_NPC:
			open_text_box(["Spren: This is one of our ancestor’s traditional drums that were broken during the war against evil. But where are the other elements of it? I wonder if the missing parts would still be around on this island…"])
			entering_rhythm = true
			enter_rhythm("res://Music/Tap_Tutorial.mp3", GlobalVariables.SONG.TAP_TUTORIAL)
				
func enter_rhythm(song_path, song_enum):
			GlobalVariables.current_song_path = song_path
			GlobalVariables.current_song = song_enum
	
func open_text_box(texts):
	for text in texts:
		text_box.queue_text(text)
	player.can_move = false

func _on_text_box_text_finished():
	if entering_rhythm:
		GlobalVariables.player_position = [playerPos.x, playerPos.y]
		GlobalVariables.previous_scene = "res://Levels/Map1.tscn"
		GlobalVariables.goto_scene("res://Levels/rhythm_level.tscn")
	player.can_move = true


func _on_text_box_force_quit():
	player.can_move = true
