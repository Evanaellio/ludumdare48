extends Control


onready var levels = $HBoxContainer/Digits


func _ready():
	pass # Replace with function body.


func updateUI():
	var current_level = PlayerVariables.level
	
	levels.text = str(current_level)
	if current_level < 1000: levels.text = "0" + levels.text
	if current_level < 100: levels.text = "0" + levels.text
	if current_level < 10: levels.text = "0" + levels.text
