extends Camera2D

var shake_amount = 0
const MAX_SHAKING = 1.75

export (NodePath) var player_path = null
onready var player = get_node_or_null(player_path)

func _ready():
	player.shaky_cam = self

func _process(delta):
		position.y = lerp(position.y, player.position.y + 184, delta * 3)
		
		if shake_amount > 0:
			set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))

func shake():
	$Tween.interpolate_property(self, "shake_amount", MAX_SHAKING, 0, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
