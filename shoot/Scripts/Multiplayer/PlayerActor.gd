var peer_id: int

var position: Vector2

var head_rotation: float

var body_rotation: float

func update_player_scene(player_scene):
	player_scene.position = position
	player_scene.head.rotation = head_rotation
	player_scene.body.rotation = body_rotation
