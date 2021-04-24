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

func destroy(): # Yes, but actually no
	$StaticBody2D/Block_grass.visible = false
	$StaticBody2D/DamageSprite.visible = false
	$StaticBody2D/CollisionShape2D.disabled = true

func self_destruct_after(time):
	yield(get_tree().create_timer(time), "timeout")
	do_damage()
	
	for i in range(3):
		yield(get_tree().create_timer(0.06), "timeout")
		do_damage()
	
