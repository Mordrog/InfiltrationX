extends KinematicBody

var gravity = -9.8
var velocity = Vector3()

onready var found_music = get_node("FoundMusic")
onready var camera = get_node("Camera")


const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5



#func _input_event(camera: Object, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
#	if event is InputEventMouseMotion:
#		var mousePosition = event.position
#		var playerToScreenPosition = camera.unproject_position(transform.basis)


func _ready():
	for child in owner.get_children():
		if child is Camera:
			camera = child

func _process(delta: float) -> void:
	var mousePosition : Vector2 = get_viewport().get_mouse_position()
	var playerToScreenPosition : Vector2 = camera.unproject_position(global_transform.origin)
	
	rotation_degrees = Vector3(0, -(rad2deg(playerToScreenPosition.angle_to_point(mousePosition)) + 90), 0)

func _physics_process(delta):
	var dir = Vector3()

#	if(Input.is_action_pressed("move_fw")):
#		dir += camera.get_global_transform().basis[2]
#
#	if(Input.is_action_pressed("move_bw")):
#		dir += -camera.get_global_transform().basis[2]
#
#	if(Input.is_action_pressed("move_l")):
#		dir += -camera.get_global_transform().basis[0]
#
#	if(Input.is_action_pressed("move_r")):
#		dir += camera.get_global_transform().basis[0]

	if(Input.is_action_pressed("move_fw")):
		dir = -global_transform.basis.z

	if(Input.is_action_pressed("move_bw")):
		dir = global_transform.basis.z

	if(Input.is_action_pressed("move_l")):
		dir = -global_transform.basis.x

	if(Input.is_action_pressed("move_r")):
		dir = global_transform.basis.x


	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta * gravity

	var hv = velocity
	hv.y = 0

	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION

	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity, Vector3(0,1,0))

var founded_by_enemies = []

func found_by_enemy(enemy):
	if founded_by_enemies.size() == 0:
		found_music.play()
	if !founded_by_enemies.has(enemy):
		founded_by_enemies.append(enemy)

func lost_by_enemy(enemy):
	if founded_by_enemies.has(enemy):
		founded_by_enemies.erase(enemy)
	if founded_by_enemies.size() == 0:
		found_music.stop()