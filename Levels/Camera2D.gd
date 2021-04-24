extends Camera2D


func _process(delta):
		position.y = lerp(position.y, $'../Player'.position.y + 184, delta * 3)
