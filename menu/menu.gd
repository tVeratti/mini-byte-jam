extends CanvasLayer


func _on_new_game_pressed() -> void:
	SceneManager.load_scene(SceneManager.MAP)
	queue_free()
