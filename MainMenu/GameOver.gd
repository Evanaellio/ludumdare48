extends CanvasLayer


onready var level_digits = $VBoxContainer/HBoxContainer/DigitsCol/DigitsLevel
onready var score_digits = $VBoxContainer/HBoxContainer/DigitsCol/DigitsScore

onready var level_best_label = $VBoxContainer/HBoxContainer/BestCol/BestLevel
onready var score_best_label = $VBoxContainer/HBoxContainer/BestCol/BestScore

func _ready():
	var run_level = PlayerVariables.level
	var run_score = PlayerVariables.score
	
	if run_level > PlayerVariables.best_level:
		level_best_label.visible = true
		PlayerVariables.best_level = run_level
		print("best level")
	else:
		level_best_label.visible = false
	
	if run_score > PlayerVariables.best_score:
		score_best_label.visible = true
		PlayerVariables.best_score = run_score
		print("best score")
	else:
		score_best_label.visible = false
	
	level_digits.text = str(run_level)
	if run_level < 1000: level_digits.text = "0" + level_digits.text
	if run_level < 100: level_digits.text = "0" + level_digits.text
	if run_level < 10: level_digits.text = "0" + level_digits.text
	
	score_digits.text = str(run_score)
	if run_score < 100000: score_digits.text = "0" + score_digits.text
	if run_score < 10000: score_digits.text = "0" + score_digits.text
	if run_score < 1000: score_digits.text = "0" + score_digits.text
	if run_score < 100: score_digits.text = "0" + score_digits.text
	if run_score < 10: score_digits.text = "0" + score_digits.text
	
	PlayerVariables.score = 0
	PlayerVariables.level = 0
	
	$AnimationPlayer.play("RIP")
	$AudioStreamPlayer.play()


func _on_NewGame_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
