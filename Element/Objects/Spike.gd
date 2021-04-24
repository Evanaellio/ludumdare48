extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_DamageArea_body_entered(body):
	print("body entered" + self.get_path_to(body))
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	
	if name == "Player" or name.begins_with("Player"):
		var player = get_node(p)
		player.knockback(Vector2(0, -25))
