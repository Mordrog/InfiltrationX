tool

extends Area

signal found_target(target)
signal lost_target(target)

export(String) var target_group = "player" setget set_target_group

export(float) var width = 5 setget set_width_vision
export(float) var height = 5 setget set_height_vision
export(float) var length = 10 setget set_length_vision

func set_target_group(new_target_group):
	if Engine.is_editor_hint():
		if new_target_group in get_groups():
			target_group = new_target_group

func set_width_vision(new_width):
	if Engine.is_editor_hint():
		if width != new_width and new_width > 0:
			width = new_width
			update_vision()

func set_height_vision(new_height):
	if Engine.is_editor_hint():
		if height != new_height and new_height > 0:
			height = new_height
			update_vision()

func set_length_vision(new_length):
	if Engine.is_editor_hint():
		if length != new_length and new_length > 0:
			length = new_length
			update_vision()

func update_vision():
	var points = [Vector3(0,0,0), Vector3(-width,-height,-length), Vector3(width,-height,-length), Vector3(-width,height,-length), Vector3(width,height,-length)]
	if find_node("CollisionShape"):
		get_node("CollisionShape").shape.points = points

var target_in_area = false
var can_see_target = false
var target

func _physics_process(delta):
	if target_in_area:
		var result = get_world().direct_space_state.intersect_ray(global_transform.origin, target.global_transform.origin, [owner])
		if result:
			if result["collider"].is_in_group(target_group):
				if !can_see_target:
					can_see_target = true
					emit_signal("found_target", target)
			else:
				if can_see_target:
					can_see_target = false
					emit_signal("lost_target", target)

func _on_VisionArea_body_entered(body: Node) -> void:
	if body.is_in_group(target_group):
		target = body as KinematicBody
		target_in_area = true

func _on_VisionArea_body_exited(body: Node) -> void:
	if body.is_in_group(target_group):
		target_in_area = false
		can_see_target = false
		emit_signal("lost_target", target)