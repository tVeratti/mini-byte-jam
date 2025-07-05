class_name PlayerNotifications
extends Node3D


@export var scroll_text_scene:PackedScene


var queue:Array = []


func render(text:String) -> void:
	if queue.is_empty():
		_render_text(text)
	
	queue.append(text)


func _render_text(text:String) -> void:
	var scroll_text_node:ScrollText = scroll_text_scene.instantiate()
	scroll_text_node.text = text
	scroll_text_node.half_done.connect(_on_half_done.bind(text))
	call_deferred("add_child", scroll_text_node)


func _on_half_done(text) -> void:
	queue.erase(text)
	
	if not queue.is_empty():
		_render_text(queue[0])
