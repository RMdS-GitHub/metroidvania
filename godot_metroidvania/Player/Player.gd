"""
PLAYER.GD

"""
extends KinematicBody2D

const DustEffetc = preload("res://Effects/DustEffect.tscn")
const PlayerBullet = preload("res://Player/PlayerBullet.tscn")

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 85
export (int) var BULLET_SPEED = 250

# Vector2(x = 0, y = 0), not moving when start.
var motion = Vector2.ZERO
# Variable so that we can jump when move_and_slide_with_snap()
var snap_vector = Vector2.ZERO
# To solve the problem with the slopes.
var just_jumped = false

onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
onready var coyoteJumpTimer = $CoyoteJumpTimer
onready var fireBulletTimer = $FireBulletTimer
onready var gun = $Sprite/PlayerGun
onready var muzzle = $Sprite/PlayerGun/Sprite/Muzzle


"""
FUNC _PHYSICS_PROCESS()

Every physics frame. Get input, apply acceleration, apply friction, 
, upadte_snap_vector for the slopes, see if it is 
jumping, apply gravity, play the animation and then move the character.
Order of the functions its important.
"""
func _physics_process(delta: float) -> void:
	# Every sinle frame.
	just_jumped = false
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	update_snap_vector()
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	# Move the character.
	move()
	
	if Input.is_action_pressed("fire") and fireBulletTimer.time_left == 0:
		fire_bullet()


"""
FUNC FIRE_BULLET()

"""
func fire_bullet():
	var bullet = Utils.instance_scene_on_main(PlayerBullet, muzzle.global_position)
	# Pointing to the right, but rotating as the gun rotates.
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
	# The fire rate from fireBulletTimer.
	fireBulletTimer.start()


"""
FUNC CREATE_DUST_EFFECT()

We need to add the function where there is movement.
Use autoload to instance the DustEffetc scene.
"""
func create_dust_effect():
	var dust_position = global_position
	# For creation with a ramdom slightly amount.
	dust_position.x += rand_range(-4, 4)
	Utils.instance_scene_on_main(DustEffetc, dust_position)


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
FUNC UPDATE_SNAP_VECTOR()

This function is to avoid that the character can't jump when using 
move_and_slide_with_snap().
"""
func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN


"""
FUNC JUMP_CHECK()

Check if is on the ground and just pressed jump key.
"""
func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			just_jumped = true
			# Without this no jump with move_and_slide_with_snap().
			snap_vector = Vector2.ZERO
	
	# Player allowed to control jump height. 
	else:
		# Makes sure we are going up still and jump is cut in halg if released.
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:  
			motion.y = -JUMP_FORCE/2
			

"""
FUNC APPLY_GRAVITY()

"""
func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		# Prevents to fall faster than jump_force. Clamps vertical speed.
		motion.y = min(motion.y, JUMP_FORCE)


"""
FUNC UPDATE_ANIMATIONS()

If input_vector different than 0, pick the sign of the input to know if 
scale.x goes to left or right and then play the run animation in the good 
direction.
If the input_vector = 0 it means that the character is not moving, play the 
idle animation then.
If character not on floor play jump animation.
"""
func update_animations(input_vector):
	# Sprite will face same side of the mouse.
	sprite.scale.x = sign(get_local_mouse_position().x)
	if input_vector.x != 0:
		spriteAnimator.play("Run")
		# To correct player moving forward anim when input is backward.
		# It's a calculation resulting in 1 or -1 to know left or right.
		# Going backwards will play animation in reverse.
		spriteAnimator.playback_speed = input_vector.x * sprite.scale.x
	else: 
		# Idle animation should never play in reverse, always forward.
		spriteAnimator.playback_speed = 1
		spriteAnimator.play("Idle")
		
	if not is_on_floor():
		spriteAnimator.play("Jump")


"""
FUNC MOVE()

Move the character. Doesn't need to apply delta to it already in.
Motion represents velocity how it changes over times.
No need to apply delta but ACCELERATION and GRAVITY yes.
In a plateformer we need a FLOOR_NORMAL to tell which direction is down. Which
direction the floor faces which is UP.
We will use move_and_slide_with_snap for the slopes.
After moving we need to check if we are in the air.
"""
func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	# Motion before it gets affected by move_and_slide_with_snap.
	var last_motion = motion
	var last_position = position
	
	motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	# Landing
	if was_in_air and is_on_floor():
		# If we land on a slope keep previous momentum.
		motion.x = last_motion.x
		create_dust_effect()
	
	# If we were on the floor and not on the floor, just left ground.
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyoteJumpTimer.start()
		
	# Prevent Sliding (hack)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x
	
	
