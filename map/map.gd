class_name Map
extends Node


@onready var grid:TileGrid = %Grid
@onready var player:Player = %Player


func _ready() -> void:
	grid.generate_tiles()
	
	# Center the player within the grid
	var center_i: = int(grid.grid_generator.grid_size / 2.0)
	var center_coord: = Vector3(center_i, 0, center_i)
	var local_pos: = grid.map_to_local(center_coord)
	player.global_position = grid.to_global(local_pos)
	
	grid.tile_entered.emit(center_coord)
