extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_drilling(drilling):
	visible = drilling
	
	if !drilling:
		$SFX.stop()
	elif !$SFX.playing:
		$SFX.play()

func _on_HitArea_body_entered(body: Node):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if visible and body.is_in_group("killable-mobs"):
		print("drilling " + name)
		get_node("CPUParticles2D_Blood").emitting = true
		
		body.queue_free()
		get_parent().add_score(30)
