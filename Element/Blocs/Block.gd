extends StaticBody2D

export (bool) var Grassy = true

func _ready():
	update_grass(Grassy)

func update_grass(var grass):
	if(grass):
		$Block_grass.set_visible(true)
		$Block.set_visible(false)
	else:
		$Block_grass.set_visible(false)
		$Block.set_visible(true)
	Grassy = grass
