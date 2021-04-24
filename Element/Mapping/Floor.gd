extends Node2D

const block : PackedScene = preload("res://Element/Blocs/Block_Basic.tscn")

func _ready():
	for ground_tile in $TileMap.get_used_cells_by_id(0): # ID 0 : ground tile
		$TileMap.set_cellv(ground_tile, -1) # Remove tile
		var world_position = $TileMap.map_to_world(ground_tile) + Vector2(16,16)
		var new_block = block.instance()
		new_block.global_position = world_position
		add_child(new_block)

var signal_counter = 0

func _on_Floor_goto_next_floor(starting_block : Node):
	# Destroy ground tiles to go to next floor
	if signal_counter == 0: # First signal call
		pass
	elif signal_counter == 2: # Delete on third signal call (to avoid removing in player sight)
		get_parent().get_parent().remove_child(get_parent())
	signal_counter += 1
