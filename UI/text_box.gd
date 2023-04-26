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
signal force_quit

func _ready():
	hide_textbox()
	effect_tween = create_tween()
	effect_tween.connect("finished", on_tween_finished)
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				change_state(State.READING)
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

func _unhandled_input(event):
	if Input.is_action_just_pressed("Force_quit"):
		text_queue = []
		hide_textbox()
		change_state(State.READY)
		emit_signal("force_quit")

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	isVisible = false
	
func show_textbox():
	textbox_container.show()
	isVisible = true
	
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
	change_state(State.FINISHED)
	

func change_state(next_state):
	current_state = next_state

