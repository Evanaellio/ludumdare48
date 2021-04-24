extends KinematicBody2D

export (int) var max_speed = 200
export (int) var acceleration = 1000
export (float) var deceleration = 0.8
export (int) var jump_speed = -300
export (int) var gravity = 1000

var velocity = Vector2.ZERO
var player_acceleration = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func get_input():
	player_acceleration.x = 0
	if Input.is_action_pressed("Right"):
		player_acceleration.x += acceleration
	if Input.is_action_pressed("Left"):
		player_acceleration.x -= acceleration

func _physics_process(delta):
	get_input()

	if player_acceleration.length() > 0:
		velocity += player_acceleration * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		velocity.x *= deceleration

	if velocity.length() < 1:
		velocity = Vector2.ZERO

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_speed
