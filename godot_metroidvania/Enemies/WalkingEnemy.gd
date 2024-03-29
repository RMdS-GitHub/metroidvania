"""
EXTENDS ENEMY.GD

"""
extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

var state

onready var sprite = $Sprite
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight


"""
FUNC _READY()

"""
func _ready() -> void:
	motion.y = 8
	state = WALKING_DIRECTION
	
	
"""
FUNC _PHYSICS_PROCESS()

"""
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not floorRight.is_colliding() or wallRight.is_colliding():
				state = DIRECTION.LEFT
			
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not floorLeft.is_colliding() or wallLeft.is_colliding():
				state = DIRECTION.RIGHT
			
	sprite.scale.x = sign(motion.x)
	# Play with deg2grad for slopes.
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(85))


