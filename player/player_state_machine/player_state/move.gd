extends PlayerState


# PlayerState: Move
# Move to intended direction


var target_position:Vector3


func enter(_previous_state_path: String, data := {}) -> void:
	target_position = player.player_direction_intent.global_position
	
	var tween: = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player, "global_position", player.player_direction_intent.global_position, 0.5)
	tween.tween_callback(func():
		finished.emit(IDLE))
