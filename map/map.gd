class_name Map
extends Node


@export var battle_scene:PackedScene

@onready var interface:CanvasLayer = %Interface
@onready var grid:Grid = %Grid
@onready var player:Player = %Player


func _ready() -> void:
	grid.generate_tiles()
	
	# Center the player within the grid
	var center_i: = int(grid.grid_generator.grid_size / 2.0)
	var center_coord: = Vector3(center_i, 0, center_i)
	var local_pos: = grid.map_to_local(center_coord)
	player.global_position = grid.to_global(local_pos)
	grid.tile_entered.emit(center_coord)
	
	grid.battle_started.connect(_on_battle_started)


func _on_battle_started(level:int) -> void:
	var battle_node:Battle = battle_scene.instantiate()
	battle_node.level = 2
	interface.add_child(battle_node)
