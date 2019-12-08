tool
extends KinematicBody

export(NodePath) var patrol_path_node

export(float) var move_speed = 5

onready var found_exclamation_mark = $FoundExclamationMark

var navigation : Navigation
var patrol_points = []

func _enter_tree() -> void:
	if owner:
		for child in owner.get_children():
			if child is Navigation:
				navigation = child
				if is_inside_tree():
					get_tree().emit_signal("node_configuration_warning_changed", self)
				break

func _get_configuration_warning() -> String:
	var warnings : = PoolStringArray()
	if not navigation and owner:
		warnings.append("%s requiers Navigation node as children of scene." % name)
	return warnings.join("\n")

func _ready():
	if patrol_path_node:
		for node in get_node(patrol_path_node).get_children():
			patrol_points.append(node.global_transform.origin)

var velocity = Vector3.ZERO
 
func _physics_process(delta):
	if velocity != Vector3.ZERO:
		var angle = rad2deg(atan2(velocity.x, velocity.z)) + 180
		
		if rotation_degrees.y < 0:
			rotation_degrees.y += 360
		elif rotation_degrees.y > 360:
			rotation_degrees.y -= 360
		
		if (rotation_degrees.y < 90 && angle > 270):
			angle -= 360
		elif (rotation_degrees.y > 270 && angle < 90):
			angle += 360
		$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, Vector3(0, angle, 0), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		$Tween.start()
		
		move_and_slide(velocity, Vector3.UP)

func _on_States_state_changed(current_state) -> void:
	if current_state == $States/TrackPlayer:
		get_tree().call_group("player", "found_by_enemy", self)
		get_tree().call_group("alarm", "alarm_start", self) 
	else:
		get_tree().call_group("player", "lost_by_enemy", self)
		get_tree().call_group("alarm", "alarm_stop", self) 
