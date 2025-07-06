extends MarginContainer


func _on_button_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.MAP)
	queue_free()
