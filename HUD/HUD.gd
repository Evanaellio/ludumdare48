extends Control


onready var level = $HBoxContainer/VBoxContainer/LevelUI
onready var health = $HBoxContainer/HealthUI
onready var score = $HBoxContainer/VBoxContainer/ScoreUI


func _ready():
	pass # Replace with function body.


func health_update():
	health.updateUI()


func level_update():
	level.updateUI()


func score_change(incremental: int):
	score.updateUI(incremental)
