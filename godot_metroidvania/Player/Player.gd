"""
PLAYER.GD

"""
extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

# Vector2(x = 0, y = 0), not moving when start.
var motion = Vector2.ZERO


"""
FUNC _PHYSICS_PROCESS()

Every physics frame. For moving the character.
"""
func _physics_process(delta: float) -> void:
	# Input player has given in this frame. In 8 directions.
	var input_vector = Vector2.ZERO
	# .x will be 1 right or -1 left or 0 not moving.
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# .y will be 1 down or -1 up or 0 not moving.
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		# The vector.2 motion += 1 or -= 1 the direction, * 512 * delta for frames.
		motion += input_vector * ACCELERATION * delta
		# Clamp the motion by float to prevent moving to quickly.
		motion = motion.clamped(MAX_SPEED)
	else:
		# Every frame we are not pressing input reduce motion by 25%.
		motion = motion.linear_interpolate(Vector2.ZERO, FRICTION)
		
	# Move the character.
	motion = move_and_slide(motion)
		
		
		
