extends PathFollow

func _ready():
	var result = get_world().direct_space_state.intersect_ray(global_transform.origin, global_transform.origin + Vector3.DOWN * 100, [], 1)
	if result:
		global_transform.origin = result.position
	else:
		get_parent().remove_child(self)