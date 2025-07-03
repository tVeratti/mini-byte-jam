extends PlayerState


# PlayerState: Move
# Move to intended direction


var target_position:Vector3
var next_tile_type:Tile.Types

var queued_next_intent:Vector3


func enter(_previous_state_path: String, data := {}) -> void:
	queued_next_intent = Vector3.ZERO
	player.input_component.direction_changed.connect(_on_direction_changed)
	
	var player_direction_intent:PlayerDirectionIntent = player.player_direction_intent
	target_position = player_direction_intent.global_position
	
	# Update the coordinates of the player now that movement is locked in
	player.coordinates_changed.emit(player_direction_intent.next_tile_coord)
	
	var tween: = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player, "global_position", target_position, 0.5)
	tween.tween_callback(func():
		if queued_next_intent.is_zero_approx():
			finished.emit(IDLE)
		else:
			finished.emit(MOVE_INTENT, { "initial_direction": queued_next_intent }))


func exit() -> void:
	player.input_component.direction_changed.disconnect(_on_direction_changed)


func _on_direction_changed(direction:Vector3) -> void:
	if not direction.is_zero_approx():
		queued_next_intent = direction
