class_name Player
extends MeshInstance3D

@onready var input_component:InputComponent = $InputComponent


func _ready() -> void:
	input_component.direction_changed.connect(_on_direction_input)


func _on_direction_input(direction:Vector3) -> void:
	print(direction)
