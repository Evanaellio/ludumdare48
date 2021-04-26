extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		body.add_coin(1)
		$CollisionShape2D.disabled = true
		$SFX.play()

func _on_SFX_finished():
	queue_free()
