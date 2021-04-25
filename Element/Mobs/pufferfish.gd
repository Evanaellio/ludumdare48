extends Sprite


var anim_idle_position


func _ready():
	self.scale.x = 0.5;
	self.scale.y = 0.5;
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")


func _on_BumperDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("pufferfish bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		player.knockback(Vector2(0, -25), global_position)


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.


func _on_PlayerDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("pufferfish detect: player entered")
		
		self.flip_h = body.global_position.y > self.global_position.y
		
		if get_node("AnimationPlayer").current_animation == "idle-loop":
			anim_idle_position = get_node("AnimationPlayer").current_animation_position
			get_node("AnimationPlayer").play("growing-once")
		elif get_node("AnimationPlayer").current_animation == "shrinking-once":
			print("pufferfish detect: player entered: reverse shrinking")
			get_node("AnimationPlayer").stop(false)
			get_node("AnimationPlayer").play_backwards("shrinking-once")
		else:
			print("pufferfish detect: player entered: already playing growing")


func _on_PlayerDetect_body_exited(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("pufferfish detect: player exited")
		
		self.flip_h = body.global_position.y > self.global_position.y
		
		if get_node("AnimationPlayer").current_animation == "idle-loop":
			anim_idle_position = get_node("AnimationPlayer").current_animation_position
			get_node("AnimationPlayer").play("shrinking-once")
		elif get_node("AnimationPlayer").current_animation == "growing-once":
			print("pufferfish detect: player entered: reverse growing")
			get_node("AnimationPlayer").stop(false)
			get_node("AnimationPlayer").play_backwards("growing-once")
		else:
			print("pufferfish detect: player entered: already playing shrinking")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")
	if (anim_name == "growing-once") || (anim_name == "shrinking-once"):
		get_node("AnimationPlayer").seek(anim_idle_position)
