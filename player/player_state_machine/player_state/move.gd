extends PlayerState


# PlayerState: Move
# Choose a new direction and lock it in, then transition into next state


var direction_intent:Vector3


func enter(_previous_state_path: String, data := {}) -> void:
	direction_intent = data.initial_direction
	
	player.input_component.direction_changed.connect(_on_direction_changed)
	player.input_component.accepted.connect(_on_accepted)


func update(_delta: float) -> void:
	pass


func exit() -> void:
	player.input_component.direction_changed.disconnect(_on_direction_changed)
	player.input_component.accepted.disconnect(_on_accepted)


func _on_direction_changed(direction:Vector3) -> void:
	if not direction.is_zero_approx() and not direction.is_equal_approx(direction_intent):
		direction_intent = direction
		player.direction_intent_changed.emit(direction_intent)


func _on_accepted() -> void:
	finished.emit(IDLE)
