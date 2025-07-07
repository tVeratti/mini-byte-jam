extends PlayerState


var grid:Grid


func enter(_previous_state_path: String, _data := {}) -> void:
	grid = get_tree().get_first_node_in_group("tile_grid")
	grid.encounter_ended.connect(_on_encounter_ended)


func exit() -> void:
	grid.encounter_ended.disconnect(_on_encounter_ended)


func _on_encounter_ended(result:Battle.Results, type:Encounter.Types) -> void:
	match(result):
		Encounter.Results.SUCCESS:
			if player.player_stats.morale > player.player_stats.attack:
				player.player_stats.buff_attack(2)
			else:
				player.player_stats.buff_morale(2)
		
		Encounter.Results.FAIL:
			player.player_stats.take_damage(1)
		
		Encounter.Results.RETRY:
			return # Do not transition
	
	finished.emit(IDLE)
