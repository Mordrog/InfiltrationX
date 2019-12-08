extends Camera

export(NodePath) var player_path_node

var player

func _ready():
	if player_path_node:
		player = get_node(player_path_node)

func _physics_process(delta) -> void:
	if player:
		global_transform.origin =  Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z)