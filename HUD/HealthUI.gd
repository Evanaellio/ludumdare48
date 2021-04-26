extends Node2D


onready var heart_0 = $Heart_0
onready var heart_1 = $Heart_1
onready var heart_2 = $Heart_2


func _ready():
	pass # Replace with function body.


func updateUI():
	var current_health = PlayerVariables.health
	
	heart_0.frame = 0 if current_health > 1 else (1 if current_health > 0 else 2)
	heart_1.frame = 0 if current_health > 3 else (1 if current_health > 2 else 2)
	heart_2.frame = 0 if current_health > 5 else (1 if current_health > 4 else 2)
