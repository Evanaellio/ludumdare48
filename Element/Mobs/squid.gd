extends Sprite

var target_player = false

func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_BumperDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		target_player = true

		print("squid bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		player.knockback(Vector2(0, -25), global_position)

		var squid = get_parent().get_parent()
		var vec = (squid.global_position - player.global_position).normalized()
		squid.apply_impulse(Vector2.ZERO, vec * 25)
		squid.look_at(squid.global_position + vec * 25)
		squid.rotation_degrees += 90

		get_node("CPUParticles2D").emitting = true


func _on_BumperDetect_body_exited(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		target_player = false


func _on_Timer_timeout():
	if !target_player:
		var squid = get_parent().get_parent()
		var vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()

		squid.apply_impulse(Vector2.ZERO, vec * 25)
		squid.look_at(squid.global_position + vec * 25)
		squid.rotation_degrees += 90
		
		$Timer.wait_time = 2 + randf()
