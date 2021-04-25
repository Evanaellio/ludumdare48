extends Node2D

export (int) var DAMAGE = 0 setget set_damage

export (bool) var Grassy = true
export(String, "Basic", "Wood") var Sprite_Type = "Basic"
export (bool) var Hidden_Coin = false
export (bool) var Spiky = false
export (int) var CoinsCount = 5

var spike = preload("res://Element/Objects/Spike.tscn")

var can_collapse_floor = false # Blocks at the bottom of the floor

signal drilled_coin(coinsCount)

const MAX_DAMAGE = 3

func _ready():
	if !Grassy || Sprite_Type != "Basic" :
		get_node("StaticBody2D/Basic/Block_grass").set_visible(false)
		get_sprite_node().set_visible(true)
	update_grass(Grassy)
	if Hidden_Coin:
		update_coin(Hidden_Coin)
	if Spiky:
		var new_spike = spike.instance()
		new_spike.position += Vector2.UP * 48
		add_child(new_spike)

func update_sprite(var bsprite):
	get_sprite_node().set_visible(false)
	Sprite_Type = bsprite
	get_sprite_node().set_visible(true)

func update_grass(var grass):
	get_sprite_node().set_visible(false)
	Grassy = grass
	get_sprite_node().set_visible(true)

func update_coin(var coin):
	$StaticBody2D/HiddenCoinSprite.visible = coin
	Hidden_Coin = coin

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
		destroy(true)
	set_damage(DAMAGE + 1)

func destroy(by_drill): # Yes, but actually no
	get_sprite_node().set_visible(false)
	if Hidden_Coin:
		$StaticBody2D/HiddenCoinSprite.visible = false
		if by_drill:
			emit_signal("drilled_coin", CoinsCount)
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
	destroy(false)
