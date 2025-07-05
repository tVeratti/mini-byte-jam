extends CanvasLayer


const MAP: = "uid://uxxs8yvjpn8m"


var main_root:Node3D


func load_scene(uid:String) -> void:
	for child in main_root.get_children():
		child.call_deferred("queue_free")
	
	var color_rect: = ColorRect.new()
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color.BLACK
	add_child(color_rect)
	
	var scene_node:Node3D = load(uid).instantiate()
	scene_node.ready.connect(_on_node_ready.bind(color_rect))
	main_root.add_child(scene_node)


func _on_node_ready(transition_node) -> void:
	transition_node.queue_free()
