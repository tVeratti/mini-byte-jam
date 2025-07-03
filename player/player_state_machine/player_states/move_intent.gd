extends PlayerState


# PlayerState: MoveIntent
# Choose a new direction and lock it in, then transition into Move state


var direction_intent:Vector3


func enter(_previous_state_path: String, data := {}) -> void:
	direction_intent = data.initial_direction
	player.direction_intent_changed.emit(direction_intent)
	player.player_direction_intent.show()
	
	player.input_component.direction_changed.connect(_on_direction_changed)
	player.input_component.accepted.connect(_on_accepted)


func exit() -> void:
	player.player_direction_intent.hide()
	player.input_component.direction_changed.disconnect(_on_direction_changed)
	player.input_component.accepted.disconnect(_on_accepted)


func _on_direction_changed(direction:Vector3) -> void:
	if not direction.is_zero_approx():
		direction_intent = direction
		player.direction_intent_changed.emit(direction_intent)


func _on_accepted() -> void:
	finished.emit(MOVE)
