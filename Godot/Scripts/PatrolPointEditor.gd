tool

extends MeshInstance

func _ready() -> void:
	if !Engine.is_editor_hint():
		hide()