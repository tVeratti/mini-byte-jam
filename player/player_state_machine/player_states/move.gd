extends PlayerState


# PlayerState: Move
# Move to intended direction


@export var move_audio:Array[AudioStream] = []


var queued_next_intent:Vector3
var target_position:Vector3

func enter(_previous_state_path: String, _data := {}) -> void:
	# Listen to direction changes to queue up the next move intent
	queued_next_intent = Vector3.ZERO
	player.input_component.direction_changed.connect(_on_direction_changed)
	
	target_position = player.player_direction_intent.global_position - Vector3(0, 0.5, 0)
	#player.boat.rotation.x = 0.0
	#player.boat.rotation.z = 0.0
	
	var tween: = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player, "global_position", target_position, 0.5)
	tween.tween_callback(_goto_next_state)
	AudioManager.play_audio.emit(move_audio.pick_random(), 5.0)


func update(delta:float) -> void:
	var direction: = player.global_position.direction_to(target_position)
	player.mesh_look(player.global_position + direction, delta)


func _goto_next_state() -> void:
	var player_direction_intent:PlayerDirectionIntent = player.player_direction_intent
	
	# Update the coordinates of the player now that movement is locked in
	player.coordinates_changed.emit(player_direction_intent.next_tile_coord)
	var next_tile_type = player_direction_intent.next_tile_type
	
	match(next_tile_type):
		Tile.Types.BATTLE, Tile.Types.JIG:
			finished.emit(ENCOUNTER)
		_:
			if queued_next_intent.is_zero_approx():
				finished.emit(IDLE)
			else:
				finished.emit(MOVE_INTENT, { "initial_direction": queued_next_intent })


func exit() -> void:
	player.input_component.direction_changed.disconnect(_on_direction_changed)


func _on_direction_changed(direction:Vector3) -> void:
	if not direction.is_zero_approx():
		queued_next_intent = direction
