extends Node2D

export(String, "Basic", "Wood", "Dark") var sprite_Type = "Basic"

var NUMBER_SPRITE = 31
var BACK_DISTRIBUTION = {
	"Basic": {0:10, 1:2, 2:3, 3:2, 4:3, 5:2, 6:3, 7:2, 8:3, 9:1},
	"Wood": {0:10, 1:2, 2:3, 3:2, 4:3, 5:2, 6:3, 7:2, 8:3, 9:1},
	"Dark": {0:16, 1:4, 2:4, 3:2, 4:3, 5:2}
}

func _ready():
	update_biome(sprite_Type)

func update_biome(new_biome):
	var new_biome_sprite = get_node(new_biome)
	var current_distribution = BACK_DISTRIBUTION[new_biome].duplicate()
	var total_weight_distribution = NUMBER_SPRITE
	for node in $Background_display.get_children():
		#new_biome_sprite.frame = randi() % new_biome_sprite.hframes
		node.texture = new_biome_sprite.texture
		var f_index = random_weighted(current_distribution, total_weight_distribution)
		current_distribution[f_index] -= 1
		total_weight_distribution -=1
		node.frame = f_index
		#print(node.frame)
	new_biome = sprite_Type

func random_weighted(weighted: Dictionary, total_weight):
	var target = rand_range(0, total_weight) as int
	for key in weighted.keys():
		var val = weighted[key]
		if val > target:
			return key
		target -= val
