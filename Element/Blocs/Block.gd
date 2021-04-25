extends Node2D

export (int) var DAMAGE = 0 setget set_damage

export (bool) var Grassy = true

const MAX_DAMAGE = 3

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
	if DAMAGE == MAX_DAMAGE:
		destroy()
	set_damage(DAMAGE + 1)

func destroy(): # Yes, but actually no
	$StaticBody2D/Block_grass.visible = false
	$StaticBody2D/DamageSprite.visible = false
	$StaticBody2D/CollisionShape2D.disabled = true

func self_destruct_after(delay, angle):
	var transition = Tween.TRANS_CUBIC
	var easing = Tween.EASE_IN
	$Tween.interpolate_method(self, "set_damage", DAMAGE + 2, MAX_DAMAGE, 0.4, transition, easing, delay)
	$Tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.3, transition, easing, delay + 0.1)
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, angle, 0.4, transition, easing, delay)
	$Tween.interpolate_property(self, "position", position, position + 64 * Vector2.DOWN, 0.4, transition, easing, delay)
	$Tween.start()

func _on_Tween_tween_all_completed():
	destroy()
