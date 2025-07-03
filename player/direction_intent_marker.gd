class_name PlayerDirectionIntent
extends MeshInstance3D


@onready var player:Player = owner
@onready var grid:TileGrid = get_tree().get_first_node_in_group("tile_grid")


func _ready() -> void:
	player.direction_intent_changed.connect(_on_player_direction_changed)


func _on_player_direction_changed(direction:Vector3) -> void:
	var flat_position: = Vector3(player.global_position.x, 0, player.global_position.z)
	var next_coord: = grid.local_to_map(flat_position) + Vector3i(direction)
	var next_tile_id: = grid.get_cell_item(next_coord)
	var next_tile_type: = TileGrid.TILE_IDS[next_tile_id]
	
	printt(next_coord, Vector3i(direction))
	global_position = grid.map_to_local(next_coord) + Vector3(0, 1, 0)
