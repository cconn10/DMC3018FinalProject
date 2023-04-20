extends Node2D

@onready var player = get_node("PlayerCat")
@onready var npc1 = get_node("Cow1")
@onready var npc2 = get_node("Cow2")
@onready var npc3 = get_node("Cow3")
@onready var npc4 = get_node("Cow4")
@onready var npc5 = get_node("Cow5")
@onready var text_box = get_node("TextBox")

@export var DISTANCE_FROM_NPC = 40

var playerPos
var npc1Pos
var npc2Pos
var npc3Pos
var npc4Pos
var npc5Pos

var entering_rhythm = false

func _ready():
	player.position.x = GlobalVariables.player_position[0]
	player.position.y = GlobalVariables.player_position[1]
	
	print($AudioStreamPlayer.stream)
	
	var stream = $AudioStreamPlayer
	if FileAccess.file_exists((GlobalVariables.overworld_music_path)):
		var sfx = load(GlobalVariables.overworld_music_path)
		stream.stream = sfx
		stream.volume_db = GlobalVariables.overworld_music_volume
		stream.play()
	
	
func _process(delta):
	playerPos = player.position
	npc1Pos = npc1.position
	npc2Pos = npc2.position
	npc3Pos = npc3.position
	npc4Pos = npc4.position
	npc5Pos = npc5.position

func _unhandled_input(event):
	if event.is_action_pressed("button"):
		if abs(playerPos.x - npc1Pos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - npc1Pos.y) < DISTANCE_FROM_NPC:
			if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.DRUM_TUTORIAL):
				open_text_box(["You already found the drum base..."])
				entering_rhythm = false
			else:
				open_text_box(["You have found one of your ancestor’s traditional drums that were broken during the war against evil. It is now your mission to find other missing parts and rebuild the drum to make it alive again."])
				entering_rhythm = true
				enter_rhythm("res://Music/Drum_Tutorial.mp3", GlobalVariables.SONG.DRUM_TUTORIAL)
		
		elif abs(playerPos.x - npc2Pos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - npc2Pos.y) < DISTANCE_FROM_NPC:
			if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.TAP_TUTORIAL):
				open_text_box(["You already found the missing piece..."])
				entering_rhythm = false
			else:
				open_text_box(["You have found a missing piece of the drum base. Use this to build a complete drum that later can be used as a weapon."])
				entering_rhythm = true
				enter_rhythm("res://Music/Tap_Tutorial.mp3", GlobalVariables.SONG.TAP_TUTORIAL)
		
		elif abs(playerPos.x - npc3Pos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - npc3Pos.y) < DISTANCE_FROM_NPC:
			if GlobalVariables.tutorials_completed.has(GlobalVariables.SONG.SHAKE_TUTORIAL):
				open_text_box(["You already found the charms..."])
				entering_rhythm = false
			else:
				open_text_box(["You have found the chain of charms that went missing during the war. Hang these on the side of your drum to create shaking sounds."])
				entering_rhythm = true
				enter_rhythm("res://Music/Shaker_Tutorial.mp3", GlobalVariables.SONG.SHAKE_TUTORIAL)					
		
		elif abs(playerPos.x - npc4Pos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - npc4Pos.y) < DISTANCE_FROM_NPC:
			if len(GlobalVariables.tutorials_completed) > 2:
				open_text_box(["Are you ready for the final tutorial?"])
				entering_rhythm = true
				enter_rhythm("res://Music/Final_Tutorial.mp3", GlobalVariables.SONG.FINAL_TUTORIAL)
			else:
				open_text_box(["You don't have a completed instrument yet..."])
				entering_rhythm = false
		
		elif abs(playerPos.x - npc5Pos.x) < DISTANCE_FROM_NPC and abs(playerPos.y - npc5Pos.y) < DISTANCE_FROM_NPC:
			if len(GlobalVariables.tutorials_completed) > 3:
				open_text_box(["Are you ready for your greatest challenge?"])
				entering_rhythm = true
				enter_rhythm("res://Music/Prototype_Song.mp3", GlobalVariables.SONG.BOSS_BATTLE)
			else:
				open_text_box(["You haven't finished the final tutorial yet..."])
				entering_rhythm = false

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
		GlobalVariables.goto_scene("res://Levels/rhythm_level.tscn")
	player.can_move = true
