extends Area2D

const TARGET_Y = 392
const SPAWN_Y = 248
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LT_SPAWN = Vector2(408, SPAWN_Y)
const LB_SPAWN = Vector2(440, SPAWN_Y)
const B_SPAWN = Vector2(472, SPAWN_Y)
const RB_SPAWN = Vector2(504, SPAWN_Y)
const RT_SPAWN = Vector2(536, SPAWN_Y)

var speed = 0
var hit = false

func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 408:
			queue_free()
			

func initialize(lane):
	if lane == 0:
		$Sprite2D.frame = 0
		position = LT_SPAWN
	elif lane == 1:
		$Sprite2D.frame = 1
		position = LB_SPAWN
	elif lane == 2:
		$Sprite2D.frame = 2
		position = B_SPAWN
	elif lane == 3:
		$Sprite2D.frame = 4
		position = RB_SPAWN
	elif lane == 4:
		$Sprite2D.frame = 5
		position = RT_SPAWN
	else:
		print("INVALID LANE" + str(lane))
		return
		
	speed = DIST_TO_TARGET / 2.0
	
func destroy():
	print("destroy")
	$Sprite2D.visible = false
	hit = true
