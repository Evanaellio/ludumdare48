extends Control


onready var score = $VBoxContainer/ScoreText/Digits

onready var incremental_0_digits = $VBoxContainer/Incremental_0/Digits
onready var incremental_1_digits = $VBoxContainer/Incremental_1/Digits
onready var incremental_2_digits = $VBoxContainer/Incremental_2/Digits

onready var incremental_0_anim = $VBoxContainer/Incremental_0/AnimationPlayer
onready var incremental_1_anim = $VBoxContainer/Incremental_1/AnimationPlayer
onready var incremental_2_anim = $VBoxContainer/Incremental_2/AnimationPlayer

var current_incremental_used = 0


func _ready():
	pass # Replace with function body.


func update_score():
	var current_score = PlayerVariables.score
	
	score.text = str(current_score)
	if current_score < 100000: score.text = "0" + score.text
	if current_score < 10000: score.text = "0" + score.text
	if current_score < 1000: score.text = "0" + score.text
	if current_score < 100: score.text = "0" + score.text
	if current_score < 10: score.text = "0" + score.text

func updateUI(incremental: int):
	update_score()
	match current_incremental_used:
		0:
			incremental_0_digits.text = str(incremental)
			incremental_0_anim.play("fade-once")
			current_incremental_used += 1
		1:
			incremental_1_digits.text = incremental_0_digits.text
			incremental_1_anim.play("fade-once")
			incremental_1_anim.seek(incremental_0_anim.current_animation_position)
			
			incremental_0_anim.stop()
			incremental_0_digits.text = str(incremental)
			incremental_0_anim.play("fade-once")
			current_incremental_used += 1
		2:
			incremental_2_digits.text = incremental_1_digits.text
			incremental_2_anim.play("fade-once")
			incremental_2_anim.seek(incremental_1_anim.current_animation_position)
			
			incremental_1_anim.stop()
			incremental_1_digits.text = incremental_0_digits.text
			incremental_1_anim.play("fade-once")
			incremental_1_anim.seek(incremental_0_anim.current_animation_position)
			
			incremental_0_anim.stop()
			incremental_0_digits.text = str(incremental)
			incremental_0_anim.play("fade-once")
			current_incremental_used += 1
		3:
			incremental_2_digits.text = incremental_1_digits.text
			incremental_2_anim.play("fade-once")
			incremental_2_anim.seek(incremental_1_anim.current_animation_position)
			
			incremental_1_anim.stop()
			incremental_1_digits.text = incremental_0_digits.text
			incremental_1_anim.play("fade-once")
			incremental_1_anim.seek(incremental_0_anim.current_animation_position)
			
			incremental_0_anim.stop()
			incremental_0_digits.text = str(incremental)
			incremental_0_anim.play("fade-once")
		_:
			print("scoreUI: WTF")
			pass

func _on_AnimationPlayer_inc0_animation_finished(anim_name):
	current_incremental_used -= 1


func _on_AnimationPlayer_inc1_animation_finished(anim_name):
	current_incremental_used -= 1


func _on_AnimationPlayer_inc2_animation_finished(anim_name):
	current_incremental_used -= 1
