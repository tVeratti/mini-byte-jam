extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.input_component.direction_changed.connect(_on_direction_changed)


func exit() -> void:
	player.input_component.direction_changed.disconnect(_on_direction_changed)


func _on_direction_changed(direction:Vector3) -> void:
	finished.emit(MOVE_INTENT, { "initial_direction": direction })
