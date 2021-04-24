extends Camera2D


func _process(delta):
	position.y = lerp(position.y, $'../Player'.position.y + 64, delta * 3)
