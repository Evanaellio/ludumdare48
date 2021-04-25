extends Sprite


func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_BumperDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("squid bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		player.knockback(Vector2(0, -25))
		get_node("CPUParticles2D").emitting = true


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.
