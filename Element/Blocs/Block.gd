extends Node2D

export (int) var DAMAGE = 0 setget set_damage

export (bool) var Grassy = true
export (String) var Sprite_Type = "Basic"

const MAX_DAMAGE = 3

func _ready():
	if Sprite_Type != "Basic":
		get_node("StaticBody2D/Basic/Block_grass").set_visible(false)
		get_sprite_node().set_visible(true)
	update_grass(Grassy)

func update_sprite(var bsprite):
	get_sprite_node().set_visible(false)
	Sprite_Type = bsprite
	get_sprite_node().set_visible(true)

func update_grass(var grass):
	get_sprite_node().set_visible(false)
	Grassy = grass
	get_sprite_node().set_visible(true)

func get_texture():
	return get_sprite_node().texture

func get_sprite_node():
	if (Grassy):
		return get_node("StaticBody2D/" + Sprite_Type + "/Block_grass")
	else:
		return get_node("StaticBody2D/" + Sprite_Type + "/Block")

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
	get_sprite_node().set_visible(false)
	$StaticBody2D/DamageSprite.visible = false
	$StaticBody2D/CollisionShape2D.disabled = true

func self_destruct_after(delay, angle):
	$Tween.interpolate_method(self, "set_damage", DAMAGE, MAX_DAMAGE, 1, Tween.TRANS_QUAD, Tween.EASE_IN, delay)
	$Tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN, delay + 1.10)
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, angle, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, delay + 1)
	$Tween.interpolate_property(self, "position", position, position + 64 * Vector2.DOWN, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, delay + 1)
	$Tween.start()

func _on_Tween_tween_all_completed():
	destroy()
