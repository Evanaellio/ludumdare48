extends Node2D

const block : PackedScene = preload("res://Element/Blocs/Block_Basic.tscn")

var starting_pos : Vector2 # Starting position for collapse
var block_distance = {}

func _ready():
	for ground_tile in $TileMap.get_used_cells_by_id(0): # ID 0 : ground tile
		$TileMap.set_cellv(ground_tile, -1) # Remove tile
		var world_position = $TileMap.map_to_world(ground_tile) + Vector2(16,16) + global_position
		var new_block = block.instance()
		new_block.global_position = world_position
		if ground_tile.y == 6: #Bottom line
			new_block.can_collapse_floor = true
			if ground_tile.x == 11:
				# Default starting position for collapse : between 2 middle blocks
				starting_pos = world_position + Vector2(16,16)
		$Blocks.add_child(new_block)

var signal_counter = 0

func distance_to_starting_pos(a, b):
	return block_distance[a] < block_distance[b]

func _on_Floor_goto_next_floor(starting_pos_signal : Vector2):
	# Destroy ground tiles to go to next floor
	if signal_counter == 0: # First signal call
		if starting_pos_signal != Vector2.ZERO:
			starting_pos = starting_pos_signal
	
		for block in $Blocks.get_children():
			block_distance[block] = starting_pos.distance_to(block.global_position)
	
		var blocks = block_distance.keys()
		blocks.sort_custom(self, "distance_to_starting_pos")
		
		for block in blocks:
			var diff = block.global_position - starting_pos
			var angle = 0
			if diff.x < 0:
				angle = 45
			elif diff.x > 0:
				angle = -45
			
			block.self_destruct_after(block_distance[block] / 450, angle)
		
		
	elif signal_counter == 2: # Delete on third signal call (to avoid removing in player sight)
		queue_free()
	signal_counter += 1
