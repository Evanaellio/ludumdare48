extends CanvasLayer


onready var score_digits = $RunScore/Digits


func _ready():
	var run_score = PlayerVariables.score
	
	score_digits.text = str(run_score)
	if run_score < 100000: score_digits.text = "0" + score_digits.text
	if run_score < 10000: score_digits.text = "0" + score_digits.text
	if run_score < 1000: score_digits.text = "0" + score_digits.text
	if run_score < 100: score_digits.text = "0" + score_digits.text
	if run_score < 10: score_digits.text = "0" + score_digits.text
	
	PlayerVariables.score = 0
	
	$AnimationPlayer.play("RIP")
	$AudioStreamPlayer.play()


func _on_NewGame_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
