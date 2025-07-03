class_name InputComponent
extends Node


signal direction_changed(dir:Vector3)
signal accepted


var direction:Vector3


func _process(_delta):
	var next_direction: = _get_direction()
	if not next_direction.is_equal_approx(direction):
		direction = next_direction
		direction_changed.emit(direction)
	
	if Input.is_action_just_released("accept"):
		accepted.emit()


func _get_direction() -> Vector3:
	var move_direction: = Vector3.ZERO
	
	# Direction only allowed in one direction, no diagonal
	if Input.is_action_pressed("move_forward"):
		move_direction.z = 1
	elif Input.is_action_pressed("move_backward"):
		move_direction.z = -1
	elif Input.is_action_pressed("move_left"):
		move_direction.x = 1
	elif Input.is_action_pressed("move_right"):
		move_direction.x = -1
	
	return move_direction
