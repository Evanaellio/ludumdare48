extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RIP")


func _on_NewGame_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
