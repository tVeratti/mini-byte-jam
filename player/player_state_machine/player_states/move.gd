extends PlayerState


# PlayerState: Move
# Move to intended direction


var target_position:Vector3
var next_tile_type:Tile.Types


func enter(_previous_state_path: String, data := {}) -> void:
	var player_direction_intent:PlayerDirectionIntent = player.player_direction_intent
	target_position = player_direction_intent.global_position
	
	# Update the coordinates of the player now that movement is locked in
	player.coordinates_changed.emit(player_direction_intent.next_tile_coord)
	
	var tween: = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player, "global_position", target_position, 0.5)
	tween.tween_callback(func():
		finished.emit(IDLE))
