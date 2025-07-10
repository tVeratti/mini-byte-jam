extends MarginContainer


@onready var miles_traveled:Label = %MilesTraveled
@onready var battles_won:Label = %BattlesWon
@onready var jigs_won:Label = %JigsWon
@onready var treasures:Label = %Treasures
@onready var new_game = %NewGame


func _ready():
	var player:Player = get_tree().get_first_node_in_group("player")
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	new_game.grab_focus()
	
	_render()


func _render() -> void:
	var stats:PlayerStats = get_tree().get_first_node_in_group("player").player_stats
	
	miles_traveled.text = str(stats.nautical_miles_traveled)
	battles_won.text = str(stats.battles_won)
	jigs_won.text = str(stats.jigs_won)
	treasures.text = str(stats.treasures_found)


func _on_new_game_pressed():
	var player:Player = get_tree().get_first_node_in_group("player")
	player.reset()
	
	SceneManager.load_scene(SceneManager.MAP)
	queue_free()
