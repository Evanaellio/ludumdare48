extends Node2D

signal goto_next_floor(breaking_block)

export (PackedScene) var RIP_Screen: PackedScene

#onready var score_ui = $CanvasLayer/ScoreUI
#onready var level_ui = $CanvasLayer/Level

onready var HUD = $CanvasLayer/HUD

var breaking_block_pos = Vector2.ZERO
var floors = []
var current_level : Node2D
var next_level : Node2D
var breaking_block_position
var is_first_level = true
#var level_count = 0



var collapse_time = 10 # initial timer, should decrease when difficulty increases

var themes = ["Basic", "Wood", "Dark"]
var current_level_theme = themes[0]
var update_theme = false

var mobs = {
	"Basic": {
		"seastar": 40,
		"pufferfish": 30,
		"squid": 30
	},
	"Wood": {
		"ghost": 45,
		"shark": 40,
		"seastar": 10,
		"pufferfish": 5,
	},
	"Dark": {
		"": 40,
		"shark": 15,
		"anglerfish": 35,
		"seastar": 10
	}
}

func _ready():
	PlayerVariables.level = 0
	PlayerVariables.health = 6

	randomize()

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
	var theme = themes[int(PlayerVariables.level / 6) % themes.size()]
	if update_theme:
		update_theme = false
		$ParallaxBackground/ParallaxLayer/Background.update_biome(theme)
	if current_level_theme != theme:
		current_level_theme = theme
		update_theme = true
	random_level.get_node('FloorBase').theme = theme
	populate_level(random_level, theme)
	add_child(random_level)
	return random_level

func goto_next_level():
	PlayerVariables.level += 1
	_on_level_changed()
	emit_signal("goto_next_floor", breaking_block_pos)
	$CollapseTimer.start(collapse_time)
	if is_first_level:
		is_first_level = false
	else:
		$Player/PlayerBody.add_score(10 * (PlayerVariables.level / 5 + 1))
		playWaterTransition()
	breaking_block_pos = Vector2.ZERO
	current_level = next_level
	var current_floorbase = current_level.get_node("FloorBase")
	#print(int(level_count / 5), ' mod ' , themes.size(), " equals ", int(level_count / 5) % themes.size())
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
	HUD.health_update()

	if hp < 1:
		Game.emit_signal("ChangeScene", RIP_Screen)

func _on_Player_score_changed(count: int, incremental: int):
	HUD.score_change(incremental)

func _on_level_changed():
	HUD.level_update()
	
	$Music.set_theme(current_level_theme)

func random_weighted(weighted: Dictionary):
	var target = rand_range(0, 100) as int
	for key in weighted.keys():
		var val = weighted[key]
		if val > target:
			return key
		target -= val

func populate_level(level, theme):
	var enemy_min = 1 + (PlayerVariables.level / 5) * 1
	var enemy_max = 3 + (PlayerVariables.level / 5) * 2

	var nb = rand_range(enemy_min, enemy_max + 1) as int

	for i in range(0, nb):
		var types = mobs[theme]

		var type = random_weighted(types)

		if type == "":
			continue

		var prefab = load("res://Element/Mobs/" + type + ".tscn")
		var mob = prefab.instance()

		mob.position.y = 96
		mob.position.x = rand_range(32.0, 23*32.0)

		level.add_child(mob)

func _on_block_coin_drilled(nb):
	$Player/PlayerBody.add_coin(5)
