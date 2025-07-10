extends MarginContainer


@onready var next_map = %NextMap


func _ready():
	next_map.grab_focus()
	
	var player:Player = get_tree().get_first_node_in_group("player")
	player.process_mode = Node.PROCESS_MODE_DISABLED

 
func _on_button_pressed() -> void:
	SceneManager.load_scene(SceneManager.MAP)
	queue_free()
