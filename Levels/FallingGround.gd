extends Node2D

signal goto_next_floor(breaking_block)

export (PackedScene) var RIP_Screen: PackedScene

onready var coins = $CanvasLayer/Score

var breaking_block_pos = Vector2.ZERO
var floors = []
var current_level : Node2D
var next_level : Node2D
var breaking_block_position
var is_first_level = true
var level_count = 0

var collapse_time = 10 # initial timer, should decrease when difficulty increases

var themes = ["Basic", "Wood"]

var mobs = {
	"basic": {
		"seastar": 50,
		"pufferfish": 40,
		"shark": 10,
	},
	"pirate": {
		
	},
	
	"dark": {
		
	}
}

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
	
	$Player/PlayerBody.connect("hp_changed", self, "_on_Player_hp_changed")
	$Player/PlayerBody.connect("score_changed", self, "_on_Player_score_changed")

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
	random_level.get_node('FloorBase').theme = themes[int(level_count / 5) % themes.size()]
	populate_level(random_level)
	add_child(random_level)
	return random_level

func goto_next_level():
	level_count += 1
	emit_signal("goto_next_floor", breaking_block_pos)
	$CollapseTimer.start(collapse_time)
	if is_first_level:
		is_first_level = false
	else:
		$Player/PlayerBody.add_score(10 * (level_count / 5 + 1))
		playWaterTransition()
	breaking_block_pos = Vector2.ZERO
	current_level = next_level
	var current_floorbase = current_level.get_node("FloorBase")
	print(int(level_count / 5), ' mod ' , themes.size(), " equals ", int(level_count / 5) % themes.size())
	next_level = instanciate_random_level(current_floorbase.get_node("End").get_global_position())
	self.connect("goto_next_floor", current_floorbase, "_on_Floor_goto_next_floor")


func _on_PlayerBody_dig_block(block):
	breaking_block_pos = block.global_position
	if block.can_collapse_floor:
		$CollapseTimer.start(max(0.01, $CollapseTimer.time_left - collapse_time / 4))
	
	
func playWaterTransition():
	if $WaterLayer/AnimationPlayer.is_playing():
		$WaterLayer/AnimationPlayer.stop(true)
		_on_AnimationPlayer_animation_finished("Water")

	$WaterLayer/AnimationPlayer.play("Water")


func _on_AnimationPlayer_animation_finished(anim_name):
	$WaterLayer.position.y += 7 * 32
	$WaterLayer/WaterCurrent.position.y = 48
	$WaterLayer/WaterNext.position.y = 400
	$WaterLayer/WaterCurrent.scale.y = 4.5
	$WaterLayer/WaterNext.scale.y = 1.5

func _on_Player_hp_changed(hp: int):
	$CanvasLayer/HP/Heart1.frame = 0 if hp > 0 else 1
	$CanvasLayer/HP/Heart2.frame = 0 if hp > 1 else 1
	$CanvasLayer/HP/Heart3.frame = 0 if hp > 2 else 1
	
	if hp < 1:
		Game.emit_signal("ChangeScene", RIP_Screen)

func _on_Player_score_changed(count: int):
	coins.text = str(count)
	if count < 100000: coins.text = "0" + coins.text
	if count < 10000: coins.text = "0" + coins.text
	if count < 1000: coins.text = "0" + coins.text
	if count < 100: coins.text = "0" + coins.text
	if count < 10: coins.text = "0" + coins.text
	coins.text = "Score: " + coins.text

func random_weighted(weighted: Dictionary):
	var target = rand_range(0, 100) as int
	for key in weighted.keys():
		var val = weighted[key]
		if val > target:
			return key
		target -= val

func populate_level(level):
	var biome = "basic"
	var enemy_min = 3
	var enemy_max = 5
	
	var nb = rand_range(enemy_min, enemy_max + 1) as int
	
	for i in range(0, nb):
		var types = mobs[biome]
		
		var type = random_weighted(types)
		
		type = types.keys()[randi() % types.size()]
		
		var prefab = load("res://Element/Mobs/" + type + ".tscn")
		var mob = prefab.instance()
		
		mob.position.y = 96
		mob.position.x = rand_range(32.0, 23*32.0)
		
		level.add_child(mob)

func _on_block_coin_drilled(nb):
	$Player/PlayerBody.add_coin(5)
