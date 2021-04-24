extends RigidBody2D

var anim = ""
var siding_left = true
var jumping = false
var stopping_jump = false

export (int) var WALK_ACCEL = 800.0
export (int) var WALK_DEACCEL = 800.0
export (int) var WALK_MAX_VELOCITY = 200.0
export (int) var AIR_ACCEL = 200.0
export (int) var AIR_DEACCEL = 200.0
export (int) var JUMP_VELOCITY = 460
export (int) var STOP_JUMP_FORCE = 900.0
export (int) var TERMINAL_SPEED = 800.0

# export (int) var max_speed = 200
# export (int) var acceleration = 1000
# export (float) var deceleration = 0.8
# export (int) var jump_speed = -300
# export (int) var gravity = 1000

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20

var floor_h_velocity = 0.0
var falling = false
var last_falling_speed = 0.0

var velocity = Vector2.ZERO
var player_acceleration = Vector2.ZERO

func _ready():
	pass # Replace with function body.

#func get_input():
#	player_acceleration.x = 0
#	if Input.is_action_pressed("Right"):
#		player_acceleration.x += acceleration
#	if Input.is_action_pressed("Left"):
#		player_acceleration.x -= acceleration

#func _physics_process(delta):
##	get_input()
#
#	if player_acceleration.length() > 0:
#		velocity += player_acceleration * delta
#		velocity.x = clamp(velocity.x, -max_speed, max_speed)
#	else:
#		velocity.x *= deceleration
#
#	if velocity.length() < 1:
#		velocity = Vector2.ZERO
#
##	velocity.y += gravity * delta
#	#velocity = move_and_slide(velocity, Vector2.UP)
#
#	if Input.is_action_just_pressed("Jump"):
#		if is_on_floor():
#			velocity.y = jump_speed


func _integrate_forces(var s):

	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var new_anim = anim
	var new_siding_left = siding_left

	# Get the controls
	var move_left = Input.is_action_pressed("Left")
	var move_right = Input.is_action_pressed("Right")
	var jump = Input.is_action_pressed("Jump")

	if jump:
		jump = true

	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1

	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x

	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air

	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true

		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step

	if on_floor:
		#$sound_fall.stop()
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		# Check jump
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			#$sound_jump.play()

		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "jumping"
		elif abs(lv.x) < 0.1:
			new_anim = "idle"
		else:
			new_anim = "run"

		falling = false
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		if lv.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"
			last_falling_speed = lv.y
			falling = true
			#if last_falling_speed > TERMINAL_SPEED - 100 and not $sound_fall.playing:
				#$sound_fall.play()
			#elif last_falling_speed <= TERMINAL_SPEED - 100:
				#$sound_fall.stop()

	# Update siding
	if new_siding_left != siding_left:
		#$Body/Sprite.flip_h = new_siding_left
		#$Head/Sprite.flip_h = new_siding_left
		siding_left = new_siding_left

	# Change animation
	if new_anim != anim:
		anim = new_anim
		#$anim.play(anim)

	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	print(lv)
	s.set_linear_velocity(lv)
