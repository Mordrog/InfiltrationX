extends SpotLight

export(Vector3) var axis = Vector3(0, 1, 0)
export(float) var rotation_speed = 25

var IsAlarm = false

func _ready() -> void:
	visible = false
	rotation_speed /= 100

func _physics_process(delta):
	if IsAlarm:
		rotate(axis, rotation_speed)

func alarm_start(caller):
	visible = true
	IsAlarm = true

func alarm_stop(caller):
	visible = false
	IsAlarm = false