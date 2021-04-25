extends Node2D


func _ready():
	var idle_anim = get_node("AnimationPlayer").get_animation("idle-loop")
	idle_anim.set_loop(true)
	get_node("AnimationPlayer").play("idle-loop")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("AnimationPlayer").play("idle-loop")
