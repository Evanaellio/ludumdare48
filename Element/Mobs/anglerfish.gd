extends Node2D

var LOOKAT_INTERVAL = 4

var player_point = null
var follow = false
var speed = 40
var flipped = false

var look_at_timer = 0

func _ready():
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")

func _process(delta):
	var move_vec = Vector2()
	if player_point:
		if follow:
			move_vec = (player_point.global_position - global_position).normalized()
			self.linear_velocity = move_vec * speed
			if look_at_timer == 0:
				look_at(global_position + move_vec * -25)
				if !flipped:
					if abs(self.rotation_degrees) >= 90:
						apply_scale(Vector2(1.0, -1.0))
						#print("turned!")
						flipped = !flipped
				else:
					if abs(self.rotation_degrees) < 90:
						apply_scale(Vector2(1.0, 1.0))
						#print("returned!")
						flipped = !flipped
			look_at_timer = look_at_timer + (1 if look_at_timer < LOOKAT_INTERVAL else -LOOKAT_INTERVAL)


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")


func _on_BumperDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		print("Anglerfish bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		_on_PlayerDetect_body_exited(body)
		player.knockback(Vector2(0, -25), global_position)


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.


func _on_PlayerDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	if name == "Player" or name.begins_with("Player"):
		if !player_point:
			player_point = get_node(p)
		follow = true
		print("Anglerfish started following")
		get_node("AnimationPlayer").stop()


func _on_PlayerDetect_body_exited(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	if name == "Player" or name.begins_with("Player"):
		if follow:
			print("Anglerfish stopped following")
			follow = false
			self.linear_velocity = Vector2.ZERO
			get_node("AnimationPlayer").play("idle-loop")
