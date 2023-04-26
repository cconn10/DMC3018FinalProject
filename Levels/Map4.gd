extends Node2D

@onready var player = get_node("Spren")
@onready var drumPiece = get_node("Cloth")
@onready var silence = get_node("Baddie")
@onready var text_box = get_node("TextBox")

@export var DISTANCE_FROM_NPC = 100

var playerPos
var drumPiecePos
var silencePos

var entering_rhythm = false

func _ready():
	player.position.x = GlobalVariables.player_position[0]
	player.position.y = GlobalVariables.player_position[1]

	if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.FINAL_TUTORIAL) and !GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.BOSS_BATTLE):
		$StaticBody2D/DrumCollision.disabled = true
		drumPiece.hide()
		silence.show()
		GlobalVariables.overworld_music_path = ""
	if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.BOSS_BATTLE):
		drumPiece.hide()
		silence.hide()
		GlobalVariables.overworld_music_path = "res://Music/Overworld_With_Ukelele.mp3"
		open_text_box(["You've fought them back this time, but they'll just keep coming back and attacking other villages.", "You can't beat them alone... you need some friends."])
		open_text_box(["Thanks for playing!!!"])
		
		
	
	var stream = $AudioStreamPlayer
	if FileAccess.file_exists((GlobalVariables.overworld_music_path)):
		var sfx = load(GlobalVariables.overworld_music_path)
		stream.stream = sfx
		stream.volume_db = GlobalVariables.overworld_music_volume
		stream.play()
	
	
func _process(delta):
	playerPos = player.position
	drumPiecePos = drumPiece.position
	silencePos = silence.position
	
	if playerPos.x < -420:
		GlobalVariables.player_position = [530, -37]
		GlobalVariables.goto_scene("res://Levels/Map3.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("button"):
		if abs(playerPos.x - drumPiecePos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - drumPiecePos.y) < DISTANCE_FROM_NPC and !$StaticBody2D/DrumCollision.disabled:
			open_text_box(["Spren: This is where I woke up this morning... It looks like it's been untouched?", "Spren: This piece of cloth should be the last element to complete my weapon. It just perfectly matches the drum, and it reflects the symbolic patterns of the Owl Forelsket."])
			entering_rhythm = true
			enter_rhythm("res://Music/Final_Tutorial.mp3", GlobalVariables.SONG.FINAL_TUTORIAL)
		elif abs(playerPos.x - silencePos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - silencePos.y) < DISTANCE_FROM_NPC:
			open_text_box(["Spren: What have you done? How could you destroy our homes, our lives?", "Mysterious Figure: ........", "Spren: You've destroyed so many lives, so much culture.", "Mysterious Figure: .........", "Spren: I guess you leave me no choice"])
			entering_rhythm = true
			enter_rhythm("res://Music/Prototype_Song.mp3", GlobalVariables.SONG.BOSS_BATTLE)
		
				
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
		GlobalVariables.previous_scene = "res://Levels/Map4.tscn"
		GlobalVariables.goto_scene("res://Levels/rhythm_level.tscn")
	player.can_move = true


func _on_text_box_force_quit():
	player.can_move = true
