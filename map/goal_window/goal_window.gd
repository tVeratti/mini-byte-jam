extends MarginContainer


func _ready():
	var player:Player = get_tree().get_first_node_in_group("player")
	player.process_mode = Node.PROCESS_MODE_DISABLED

 
func _on_button_pressed() -> void:
	SceneManager.load_scene(SceneManager.MAP)
	queue_free()
