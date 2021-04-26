extends Sprite


var is_triggered = false
var detected_player = false
var triggered_count = 0
var body_flipped = false
var body_h_flipped = false
var dashing = false

func _ready():
	get_node("AnimationPlayer").play("idle-loop")

	get_node("CPUParticles2D").emitting = is_triggered

func stop_dash():
	var shark = get_parent().get_parent()
	if body_flipped:
		get_parent().rotation_degrees = -90.0
		body_flipped = false
	if body_h_flipped:
		self.rotation_degrees += 180
		body_h_flipped = false
	shark.linear_velocity = Vector2.ZERO
	shark.angular_velocity = 0.0
	shark.rotation_degrees = 0.0
	get_node("AnimationPlayer").play()
	dashing = false


func _on_BumperDetect_body_entered(body):
	if is_triggered:
		var p = self.get_path_to(body)
		var name = p.get_name(p.get_name_count() - 1)

		if name == "Player" or name.begins_with("Player"):
			print("shark bumper: player bumped")
			var player = get_node(p)
			player.hurt()
#			if dashing:
#				stop_dash()
			player.knockback(Vector2(0, -25), global_position)


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.


func _on_PlayerDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		print("shark detect: player entered")
		var player = get_node(p)
		detected_player = true

		if is_triggered:
			#print("shark is not happy")
			if triggered_count >= 1 && !dashing:
				print("shark attacks")
#				var anim_timer = get_node("AnimationPlayer").current_animation_position
#				body_flipped = anim_timer < 2.0 || anim_timer > 6.0
#				if body_flipped:
#					get_parent().rotation_degrees = 90.0
#				get_node("AnimationPlayer").stop()
#				var shark = get_parent().get_parent()
#				var vec = (shark.global_position - player.global_position).normalized()
#				shark.apply_impulse(Vector2.ZERO, vec * -100)
#				var old_angle = shark.rotation_degrees
#				shark.look_at(shark.global_position + vec * 25)
#				body_h_flipped = abs(old_angle - shark.rotation_degrees)  > 90
#				dashing = true

		else:
			is_triggered = true
			get_node("CPUParticles2D").emitting = is_triggered
			get_node("AnimationPlayer").set_speed_scale(4)


func _on_PlayerDetect_body_exited(body):
	pass
#	if dashing:
#		stop_dash()


func _on_AnimationPlayer_animation_finished(anim_name):
	if is_triggered:
		if detected_player:
			triggered_count += 1
			detected_player = false
		else:
			triggered_count -= 1
			if triggered_count <=0:
				triggered_count = 0
				is_triggered = false
				get_node("CPUParticles2D").emitting = is_triggered
				get_node("AnimationPlayer").set_speed_scale(1)
				print("shark is happy")

	get_node("AnimationPlayer").play("idle-loop")
