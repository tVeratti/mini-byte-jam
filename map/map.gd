class_name Map
extends Node


@onready var grid:TileGrid = %Grid
@onready var player:Player = %Player


func _ready() -> void:
	# Center the player within the grid
	var center_i: = int(grid.get_used_cells().size() / 100.0 / 2.0)
	var center_coord: = Vector3(center_i, 1, center_i)
	var local_pos: = grid.map_to_local(center_coord)
	player.global_position = grid.to_global(local_pos)
