extends Node2D

export(String, "Basic", "Wood", "Dark") var Sprite_Type = "Basic"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_sprite_type(Sprite_Type) # Replace with function body.

func update_sprite_type(type: String):
	if type == "Basic":
		$Sprite.set_frame(0)
	if type == "Wood":
		$Sprite.set_frame(1)
	if type == "Dark":
		$Sprite.set_frame(2)
	Sprite_Type = Sprite_Type

func _on_DamageArea_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		print("spike bumper: player bumped")
		var player = get_node(p)
		player.hurt()
		player.knockback(Vector2(0, -25))

	elif body.is_in_group("killable-mobs"):
		print("spiking " + name)
		body.queue_free()
