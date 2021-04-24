extends Camera2D


func _process(delta):
		position.y = lerp(position.y, $'../Player/PlayerBody'.position.y + 184, delta * 3)
