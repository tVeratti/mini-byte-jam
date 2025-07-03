class_name Player
extends MeshInstance3D


signal direction_intent_changed(direction:Vector3)


@onready var input_component:InputComponent = $InputComponent
@onready var player_state_machine = %PlayerStateMachine
@onready var player_direction_intent:PlayerDirectionIntent = %PlayerDirectionIntent
@onready var state_label:Label3D = %StateLabel
@onready var camera_3d:Camera3D = $Camera3D


func _process(_delta):
	camera_3d.look_at(global_position)
	state_label.text = player_state_machine.state.name
