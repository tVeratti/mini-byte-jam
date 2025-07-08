class_name PlayerStateMoveIntent
extends PlayerState


# PlayerState: MoveIntent
# Choose a new direction and lock it in, then transition into Move state

const VALID_DIRECTIONS: = [
	Vector3.FORWARD,
	Vector3.BACK,
	Vector3.LEFT,
	Vector3.RIGHT]


var direction_intent:Vector3


func enter(_previous_state_path: String, data := {}) -> void:
	direction_intent = data.initial_direction
	player.direction_intent_changed.emit(direction_intent)
	
	player.input_component.direction_changed.connect(_on_direction_changed)
	player.input_component.accept_released.connect(_on_accepted)


func exit() -> void:
	player.player_direction_intent.hide()
	player.input_component.direction_changed.disconnect(_on_direction_changed)
	player.input_component.accept_released.disconnect(_on_accepted)


func _on_direction_changed(direction:Vector3) -> void:
	if not direction_intent.is_zero_approx() and direction.is_zero_approx():
		_on_accepted()
	elif VALID_DIRECTIONS.has(direction):
		direction_intent = direction
		player.direction_intent_changed.emit(direction_intent)


func _on_accepted() -> void:
	if player.player_direction_intent.next_tile_type == Tile.Types.IMPASSABLE:
		return
	
	finished.emit(MOVE)
