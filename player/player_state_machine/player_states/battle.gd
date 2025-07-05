extends PlayerState


var grid:Grid


func enter(_previous_state_path: String, _data := {}) -> void:
	grid = get_tree().get_first_node_in_group("tile_grid")
	grid.battle_ended.connect(_on_battle_ended)


func exit() -> void:
	grid.battle_ended.disconnect(_on_battle_ended)


func _on_battle_ended(result:Battle.Results) -> void:
	match(result):
		Battle.Results.SUCCESS:
			player.player_stats.buff_attack(1)
			player.player_stats.buff_stamina(1)
		Battle.Results.FAIL:
			player.player_stats.take_damage(1)
	
	finished.emit(IDLE)
