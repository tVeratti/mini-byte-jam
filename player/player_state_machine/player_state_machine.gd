class_name PlayerStateMachine
extends Node


@export var initial_state: PlayerState = null


@onready var state: PlayerState


func _ready() -> void:
	state = _get_initial_state()
	
	for state_node:PlayerState in find_children("*", "PlayerState"):
		state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready
	state.enter("")


func _process(delta: float) -> void:
	state.update(delta)


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	print("transition to ", target_state_path)
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)


func _get_initial_state() -> PlayerState:
	return initial_state if initial_state != null else get_child(0)
