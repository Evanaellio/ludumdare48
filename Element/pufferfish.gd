extends Sprite


var anim_idle_position


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale.x = 0.5;
	self.scale.y = 0.5;
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")


func _on_BumperDetect_body_entered(body):
	pass


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.


func _on_PlayerDetect_body_entered(body):
	if body.name == "Player":
		anim_idle_position = get_node("AnimationPlayer").current_animation_position
		get_node("AnimationPlayer").play("growing-once")


func _on_PlayerDetect_body_exited(body):
	if body.name == "Player":
		anim_idle_position = get_node("AnimationPlayer").current_animation_position
		get_node("AnimationPlayer").play("shrinking-once")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")
	if (anim_name == "growing-once") || (anim_name == "shrinking-once"):
		get_node("AnimationPlayer").seek(anim_idle_position)
