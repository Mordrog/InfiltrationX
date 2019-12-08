extends "../IState.gd"

export(float) var target_lost_timeout = 4

var path = []
var path_ind = 0

var target_vision_lost = true
var target_lost_timer = 0

onready var vision_area = owner.get_node("VisionArea")

func enter():
	pass # Replace with function body.

func update(delta):
	var next_position = get_next_position_along_path()
	if next_position != Vector3.ZERO:
		owner.velocity = (next_position - owner.global_transform.origin).normalized() * owner.move_speed
	else:
		owner.velocity = Vector3.ZERO
	
	if target_vision_lost:
		target_lost_timer += delta
		if target_lost_timer > target_lost_timeout:
			owner.found_exclamation_mark.visible = false
			emit_signal('finished', "Patrol")

func get_next_position_along_path():
	if owner.navigation:
		if vision_area.target:
			var distance = get_plane_distance(owner.global_transform.origin, vision_area.target.global_transform.origin)
			if distance > 3.0:
				path = owner.navigation.get_simple_path(owner.global_transform.origin, vision_area.target.global_transform.origin)
				if path.size() > 1:
					return path[1]
				elif path.size() == 1:
					return path[0]
	return Vector3.ZERO

func get_plane_distance(start_position : Vector3, target_position : Vector3):
	start_position.y = 0
	target_position.y = 0
	return start_position.distance_to(target_position)

func _on_VisionArea_found_target(target) -> void:
	target_vision_lost = false
	target_lost_timer = 0

func _on_VisionArea_lost_target(target) -> void:
	target_vision_lost = true
