class_name Player
extends MeshInstance3D


signal direction_intent_changed(direction:Vector3)


@onready var input_component:InputComponent = $InputComponent
@onready var player_state_machine = %PlayerStateMachine
@onready var state_label:Label3D = %StateLabel


func _process(_delta):
	state_label.text = player_state_machine.state.name
