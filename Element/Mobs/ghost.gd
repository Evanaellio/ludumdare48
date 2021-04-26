extends Node2D

var player_ref: Node2D = null

var speed = 20

var sprites = {
	0: 5,
	1: 25,
	2: 25,
	3: 20,
	4: 20,
	5: 5,
}

func random_weighted(weighted: Dictionary):
	var target = rand_range(0, 100) as int
	for key in weighted.keys():
		var val = weighted[key]
		if val > target:
			return key
		target -= val

func _ready():
	var sprite = random_weighted(sprites)
	$Sprite.frame = sprite

func _process(delta):
	var move_vec = Vector2()

	if player_ref:
		move_vec = (player_ref.global_position - global_position).normalized()

	else:
		move_vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()

	position += move_vec * speed * delta

func _on_DetectArea_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		player_ref = body

func _on_DetectArea_body_exited(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		player_ref = null

func _on_BumperArea_body_entered(body):
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)

	if name == "Player" or name.begins_with("Player"):
		body.hurt()
		#body.knockback(Vector2(0, -25), global_position)
