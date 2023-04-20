extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

@export var isVisible = false

enum State {READY, READING, FINISHED}

const CHAR_READ_RATE = 0.05

var effect_tween: Tween
var current_state = State.READY

var text_queue = []

signal text_finished

func _ready():
	hide_textbox()
	effect_tween = create_tween()
	effect_tween.connect("finished", on_tween_finished)
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				change_state(State.READING)
				isVisible = true
				show_textbox()
				display_text()
		State.READING:
			if Input.is_action_just_pressed("close_text"):
				label.visible_ratio = 1.0
				effect_tween.stop()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("close_text"):
				change_state(State.READY)
				if text_queue.is_empty():
					emit_signal("text_finished")
					hide_textbox()
					isVisible = false
	

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func queue_text(next_text):
	if !isVisible:
		text_queue.push_back(next_text)
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	if effect_tween:
		effect_tween.kill()
	effect_tween = create_tween()
	effect_tween.set_trans(Tween.TRANS_LINEAR)
	effect_tween.set_ease(Tween.EASE_IN_OUT)
	effect_tween.tween_property(label, "visible_ratio", 0.0, 0)
	effect_tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	
func on_tween_finished():
	print("foo")
	change_state(State.FINISHED)
	

func change_state(next_state):
	current_state = next_state
#	match current_state:
#		State.READY:
#			print(current_state)
#		State.READING:
#			print(current_state)
#		State.FINISHED:
#			print(current_state)
			

