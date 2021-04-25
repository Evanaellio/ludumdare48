extends Node2D


var rng = RandomNumberGenerator.new()


func _ready():
	get_node("AnimationPlayer").play("idle-loop")
	rng.randomize()

func _on_AnimationPlayer_animation_finished(anim_name):
	var animation_list = get_node("AnimationPlayer").get_animation_list()
	
	var anim_select = rng.randi_range(0, animation_list.size() - 1)
	
	get_node("AnimationPlayer").play(animation_list[anim_select])
