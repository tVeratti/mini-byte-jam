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
			if player.player_stats.morale > player.player_stats.attack:
				player.player_stats.buff_attack(2)
			else:
				player.player_stats.buff_morale(2)
		
		Battle.Results.FAIL:
			player.player_stats.take_damage(1)
		
		Battle.Results.RETRY:
			return # Do not transition
	
	finished.emit(IDLE)
