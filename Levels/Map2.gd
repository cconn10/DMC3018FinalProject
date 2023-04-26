extends Node2D

@onready var player = get_node("Spren")
@onready var drumPiece = get_node("Piece")
@onready var text_box = get_node("TextBox")

@export var DISTANCE_FROM_NPC = 100

var playerPos
var drumPiecePos

var entering_rhythm = false

func _ready():
	player.position.x = GlobalVariables.player_position[0]
	player.position.y = GlobalVariables.player_position[1]
	
	if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.DRUM_TUTORIAL):
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
	print(playerPos)
	if playerPos.y < -417:
		GlobalVariables.player_position = [-30, 255]
		GlobalVariables.goto_scene("res://Levels/Map1.tscn")
	elif playerPos.x > 500:
		GlobalVariables.player_position = [-530, -10]
		GlobalVariables.goto_scene("res://Levels/Map3.tscn")
		
		

func _unhandled_input(event):
	if event.is_action_pressed("button"):
		if abs(playerPos.x - drumPiecePos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - drumPiecePos.y) < DISTANCE_FROM_NPC and !$StaticBody2D/DrumCollision.disabled:
			open_text_box(["Spren: This must be the missing piece of the drum base. I can now use this to build the drum and turn it into a weapon. Hmm… I feel like it is still missing something. What could it be?"])
			entering_rhythm = true
			enter_rhythm("res://Music/Drum_Tutorial.mp3", GlobalVariables.SONG.DRUM_TUTORIAL)
				
func enter_rhythm(song_path, song_enum):
			GlobalVariables.current_song_path = song_path
			GlobalVariables.current_song = song_enum
	
func open_text_box(texts):
	for text in texts:
		print(text)
		text_box.queue_text(text)
	player.can_move = false

func _on_text_box_text_finished():
	if entering_rhythm:
		GlobalVariables.player_position = [playerPos.x, playerPos.y]
		GlobalVariables.previous_scene = "res://Levels/Map2.tscn"
		GlobalVariables.goto_scene("res://Levels/rhythm_level.tscn")
	player.can_move = true


func _on_text_box_force_quit():
	player.can_move = true
