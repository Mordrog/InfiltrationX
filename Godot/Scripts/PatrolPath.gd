tool
extends Path

func _ready():
    pass
	
var editor # for caching EditorInterface
var is_selected = false



func _enter_tree():
	if Engine.is_editor_hint():
		var plugin = EditorPlugin.new()
		editor = plugin.get_editor_interface().get_selection()
		editor.connect("selection_changed", self, "_on_selection_changed")
		plugin.queue_free()

func _on_selection_changed():
	var path_nodes = []
	path_nodes.append(self)
	for node in get_children():
		if node is PathFollow:
			path_nodes.append(node)

	for node in path_nodes:
		if node in editor.get_selected_nodes():
			if (!is_selected):
				for node in path_nodes:
					node.visible = true
			is_selected = true
			break
	
		else:
			if (is_selected):
				for node in path_nodes:
					node.visible = false
			is_selected = false