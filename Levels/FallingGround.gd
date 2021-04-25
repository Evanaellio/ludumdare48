extends Node2D

signal goto_next_floor(breaking_block)

var breaking_block_pos = Vector2.ZERO
var floors = []
var current_level : Node2D
var next_level : Node2D
var breaking_block_position
var is_first_level = true

func _ready():
	load_floors()
	next_level = instanciate_random_level(transform.origin)
	goto_next_level()
	
	# reset water position
	$WaterLayer/WaterCurrent.rotation_degrees = 0
	$WaterLayer/WaterCurrent.position.y = 48
	$WaterLayer/WaterNext.position.y = 400
	$WaterLayer/WaterCurrent.scale.y = 4.5
	$WaterLayer/WaterNext.scale.y = 1.5

func load_floors():
	var dir = Directory.new()
	var path = "res://Levels/Floors"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				floors.append(load(path + "/" + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func instanciate_random_level(position):
	var choice = floors[randi() % floors.size()]
	var random_level =  choice.instance()
	random_level.global_position = position
	add_child(random_level)
	return random_level

func goto_next_level():
	if is_first_level:
		is_first_level = false
	else:
		playWaterTransition()
	
	emit_signal("goto_next_floor", breaking_block_pos)
	breaking_block_pos = Vector2.ZERO
	current_level = next_level
	var current_floorbase = current_level.get_node("FloorBase")
	next_level = instanciate_random_level(current_floorbase.get_node("End").get_global_position())
	self.connect("goto_next_floor", current_floorbase, "_on_Floor_goto_next_floor")


func _on_PlayerBody_dig_block(position):
	breaking_block_pos = position
	
func playWaterTransition():
	$WaterLayer/AnimationPlayer.stop(true)
	$WaterLayer/AnimationPlayer.play("Water")


func _on_AnimationPlayer_animation_finished(anim_name):
	$WaterLayer.position.y += 7 * 32
	$WaterLayer/WaterCurrent.position.y = 48
	$WaterLayer/WaterNext.position.y = 400
	$WaterLayer/WaterCurrent.scale.y = 4.5
	$WaterLayer/WaterNext.scale.y = 1.5
