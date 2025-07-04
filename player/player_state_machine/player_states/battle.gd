extends PlayerState


var grid:Grid


func enter(previous_state_path: String, data := {}) -> void:
	grid = get_tree().get_first_node_in_group("tile_grid")
	grid.battle_ended.connect(_on_battle_ended)


func exit() -> void:
	grid.battle_ended.disconnect(_on_battle_ended)


func _on_battle_ended() -> void:
	finished.emit(IDLE)
