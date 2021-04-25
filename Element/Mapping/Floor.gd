extends Node2D

const block : PackedScene = preload("res://Element/Blocs/Block_Basic.tscn")

var starting_pos : Vector2 # Starting position for collapse
var block_distance = {}

enum Tiles {EMPTY = -1, GROUND, COIN, SPIKE, WALL}

func _ready():
	for tile_pos in $TileMap.get_used_cells(): # ID 0 : ground tile
		configure_block(tile_pos, $TileMap.get_cellv(tile_pos))
	$TileMap.queue_free()

var signal_counter = 0

func configure_block(tile_pos, tile):
	var world_position = $TileMap.map_to_world(tile_pos) + Vector2(16,16) + global_position
	var new_block = block.instance()
	new_block.global_position = world_position
	if tile_pos.y == 6: #Bottom line
		new_block.can_collapse_floor = true
		if tile_pos.x == 11:		
			starting_pos = world_position + Vector2(16,16) # Default starting position for collapse : between the 2 middle blocks
	
	var tile_above = $TileMap.get_cellv(tile_pos + Vector2.UP)
	new_block.Grassy = (tile_above == Tiles.EMPTY and not tile_pos.y == 0)
	new_block.Hidden_Coin = (tile == Tiles.COIN)
	new_block.Spiky = (tile == Tiles.SPIKE)
	
	
	# Forward drilled signal to FallingGround
	new_block.connect("drilled_coin", get_parent().get_parent(), "_on_block_coin_drilled")
	$Blocks.add_child(new_block)


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
