extends Area2D


var anim_idle_position


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite").scale.x = 0.5;
	get_node("Sprite").scale.y = 0.5;
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")


func _on_Pufferfish2DArea_body_entered(body):
	anim_idle_position = get_node("AnimationPlayer").current_animation_position
	get_node("AnimationPlayer").play("growing-once")


func _on_Pufferfish2DArea_body_exited(body):
	anim_idle_position = get_node("AnimationPlayer").current_animation_position
	get_node("AnimationPlayer").play("shrinking-once")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")
	if (anim_name == "growing-once") || (anim_name == "shrinking-once"):
		get_node("AnimationPlayer").seek(anim_idle_position)


func _on_BumperDetect_body_entered(body):
	pass


func _on_BumperDetect_body_exited(body):
	pass # Replace with function body.
