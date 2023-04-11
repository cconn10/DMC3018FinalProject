extends Node2D

@onready var player = get_node("PlayerCat")
@onready var npc1 = get_node("Cow1")
@onready var npc2 = get_node("Cow2")
@onready var npc3 = get_node("Cow3")

signal to_rhythm(song_name)

var playerPos
var npc1Pos
var npc2Pos
var npc3Pos

func _ready():
	pass
	
func _process(delta):
	playerPos = player.position
	npc1Pos = npc1.position
	npc2Pos = npc2.position
	npc3Pos = npc3.position

func _unhandled_input(event):
	if event.is_action_pressed("button") and abs(playerPos.x - npc1Pos.x) < 20 and abs(playerPos.y - npc1Pos.y) < 20:
		emit_signal("to_rhythm", "res://Music/Drum_Tutorial.mp3")
	elif event.is_action_pressed("button") and abs(playerPos.x - npc2Pos.x) < 20 and abs(playerPos.y - npc2Pos.y) < 20:
		emit_signal("to_rhythm", "res://Music/Shaker_Tutorial.mp3")
	elif event.is_action_pressed("button") and abs(playerPos.x - npc3Pos.x) < 20 and abs(playerPos.y - npc3Pos.y) < 20:
		emit_signal("to_rhythm", "res://Music/Prototype_song.mp3")
