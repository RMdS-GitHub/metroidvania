"""
PLAYER.GD

"""
extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

# Vector2(x = 0, y = 0), not moving when start.
var motion = Vector2.ZERO


"""
FUNC _PHYSICS_PROCESS()

Every physics frame. For moving the character. Order of the functions is
important.
"""
func _physics_process(delta: float) -> void:
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	# Move the character.
	move()
		
		
"""
FUNC GET_INPUT_VECTOR()

"""
func get_input_vector():
# Input player as given in this frame. In platformer directions.
	var input_vector = Vector2.ZERO
	# .x will be 1 right or -1 left or 0 not moving.
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector
	
	
"""
FUNC APPLY_HORIZONTAL_FORCE

"""
func apply_horizontal_force(input_vector, delta):
	# There is movement, apply acceleration.
	if input_vector.x != 0:
		
		# The vector.2 motion += 1 or -= 1 the direction, * 512 * delta for frames.
		# Delta needs to be applied to every changing values.
		motion.x += input_vector.x * ACCELERATION * delta
		# Clamp the motion by float to prevent moving to quickly.
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)


"""
FUNC APPLY_FRICTION

"""
func apply_friction(input_vector):
	# Not pressing any button.
	if input_vector.x == 0 and is_on_floor():
		# Every frame we are not pressing input reduce motion by 25%.
		motion.x = lerp(motion.x, 0, FRICTION)


"""
FUNC JUMP_CHECK()

Check if is on the ground and just pressed jump key.
"""
func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	# Player allowed to control jump height. 
	else:
		# Makes sure we are going up still and jump is cut in halg if released.
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:  
			motion.y = -JUMP_FORCE/2
			

"""
FUNC APPLY_GRAVITY()

"""
func apply_gravity(delta):
	#if not is_on_floor():
		motion.y += GRAVITY * delta
		# Prevents to fall faster than jump_force. Clamps vertical speed.
		motion.y = min(motion.y, JUMP_FORCE)

"""
FUNC MOVE()

Move the character. Doesn't need to apply delta to it already in.
Motion represents velocity how it changes over times.
No need to apply delta but ACCELERATION and GRAVITY yes.
In a plateformer we need a FLOOR_NORMAL to tell which direction is down. Which
direction the floor faces which is UP.
"""
func move():
	motion = move_and_slide(motion, Vector2.UP)
	
	
	
