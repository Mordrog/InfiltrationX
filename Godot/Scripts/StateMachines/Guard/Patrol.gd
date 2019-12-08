extends "../IState.gd"



var patrol_position_index = 0
var path = []
var path_ind = 0

func enter():
	pass # Replace with function body.

func update(delta):
	var next_position = get_next_position_along_path()
	if next_position != Vector3.ZERO:
		owner.velocity = (next_position - owner.global_transform.origin).normalized() * owner.move_speed
	else:
		owner.velocity = Vector3.ZERO

func get_next_position_along_path():
	if owner.navigation:
		if path_ind < path.size():
			var move_vec = (path[path_ind] - owner.global_transform.origin)
			if move_vec.length() < 0.1:
				path_ind += 1
			else:
				return path[path_ind]
		elif owner.patrol_points.size() > 0:
			patrol_position_index += 1
			if patrol_position_index >= owner.patrol_points.size():
				patrol_position_index = 0
			path = owner.navigation.get_simple_path(owner.global_transform.origin, owner.patrol_points[patrol_position_index])
			path_ind = 0
	
	return Vector3.ZERO

func _on_VisionArea_found_target(target) -> void:
	emit_signal('finished', "TrackPlayer")
	owner.found_exclamation_mark.visible = true
