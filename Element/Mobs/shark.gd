extends Sprite


var is_triggered = false
var detected_player = false
var triggered_count = 0

func _ready():
	get_node("AnimationPlayer").play("idle-loop")
	
	get_node("CPUParticles2D").emitting = is_triggered


func _on_BumperDetect_body_entered(body):
	pass # Replace with function body.


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.


func _on_PlayerDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("shark detect: player entered")
		
		detected_player = true
		
		if is_triggered:
			print("shark is not happy")
			if triggered_count >= 2:
				print("shark attacks")
		else:
			is_triggered = true
			get_node("CPUParticles2D").emitting = is_triggered
			get_node("AnimationPlayer").set_speed_scale(4)


func _on_PlayerDetect_body_exited(body):
	pass


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
