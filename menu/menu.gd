extends CanvasLayer


func _on_new_game_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.MAP)
	queue_free()
