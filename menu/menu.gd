extends CanvasLayer


@onready var new_game = %NewGame


func _ready() -> void:
	new_game.grab_focus()


func _on_new_game_pressed() -> void:
	SceneManager.load_scene(SceneManager.MAP)
	queue_free()
