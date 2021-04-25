extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")


func _on_BumperDetect_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		print("seastar bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		player.knockback(Vector2(0, -25))


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.
