extends Node2D

export (int) var DAMAGE = 0 setget set_damage

export (bool) var Grassy = true

func _ready():
	update_grass(Grassy)

func update_grass(var grass):
	if(grass):
		$StaticBody2D/Block_grass.set_visible(true)
		$StaticBody2D/Block.set_visible(false)
	else:
		$StaticBody2D/Block_grass.set_visible(false)
		$StaticBody2D/Block.set_visible(true)
	Grassy = grass

func set_damage(dmg):
	DAMAGE = dmg
	if DAMAGE < 0:
		DAMAGE = 0
	if DAMAGE > 3:
		DAMAGE = 3
	$StaticBody2D/DamageSprite.frame = DAMAGE

func do_damage():
	if DAMAGE == 3:
		destroy()
	set_damage(DAMAGE + 1)

func destroy():
	queue_free()
