extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -300
export (int) var gravity = 1000

var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func get_input():
    velocity.x = 0
    if Input.is_action_pressed("Right"):
        velocity.x += speed
    if Input.is_action_pressed("Left"):
        velocity.x -= speed

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    velocity = move_and_slide(velocity, Vector2.UP)
    if Input.is_action_just_pressed("Up"):
        if is_on_floor():
            velocity.y = jump_speed
