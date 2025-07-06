class_name PlayerDirectionIntent
extends MeshInstance3D


const POSITION_OFFSET: = Vector3(0, 1, 0)


var next_tile_coord:Vector3
var next_tile_type:Tile.Types


@onready var player:Player = owner


func _ready() -> void:
	player.direction_intent_changed.connect(_on_player_direction_changed)


func _on_player_direction_changed(direction:Vector3) -> void:
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	var flat_position: = Vector3(player.global_position.x, 0, player.global_position.z)
	next_tile_coord = grid.local_to_map(flat_position) + Vector3i(direction)
	
	if grid.tiles.has(next_tile_coord):
		next_tile_type = grid.tiles[next_tile_coord]
		global_position = grid.map_to_local(next_tile_coord) + POSITION_OFFSET
		
		var tile_type:Tile.Types = grid.tiles[next_tile_coord]
		visible = tile_type != Tile.Types.IMPASSABLE
