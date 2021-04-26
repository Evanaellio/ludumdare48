extends Node2D

var BPM = 96.0

var beat = 0

var playing = null
var next = null

func _ready():
	$Timer.wait_time = 60.0 / BPM
	$Timer.start()

func set_theme(theme):
	if playing != theme:
		next = theme

func _on_Timer_timeout():
	if beat == 0 and next:
		if playing:
			(get_node(playing) as AudioStreamPlayer).stop()

		(get_node(next) as AudioStreamPlayer).play()
		playing = next
		next = null
	
	beat += 1
	if beat == 4:
		beat = 0
