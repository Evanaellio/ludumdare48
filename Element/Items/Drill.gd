extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitArea_body_entered(body: Node):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if visible and body.is_in_group("killable-mobs"):
		print("drilling " + name)
		body.queue_free()
		get_parent().add_score(100)
