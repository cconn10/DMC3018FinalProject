extends Node2D

@onready var player = get_node("PlayerCat")
@onready var npc1 = get_node("Cow1")
@onready var npc2 = get_node("Cow2")
@onready var npc3 = get_node("Cow3")

signal change_song(song_name)

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
	var path
	var stream = AudioStreamMP3.new()
	if event.is_action_pressed("button"):
		if abs(playerPos.x - npc1Pos.x) < 20 and abs(playerPos.y - npc1Pos.y) < 20:
			get_tree().change_scene_to_file("res://Levels/rhythm_level.tscn")
