class_name GridPlayerMovement
extends Node


@export var player:Player
@export var grid:TileGrid


var can_move:bool = true


func _ready() -> void:
	player.direction_intent_changed.connect(_on_player_direction_changed)


func _on_player_direction_changed(direction:Vector3) -> void:
	if can_move:
		var flat_position: = Vector3(player.global_position.x, 0, player.global_position.y)
		var next_coord: = grid.to_local(flat_position) + direction
		var next_tile_id: = grid.get_cell_item(next_coord)
		var next_tile_type: = TileGrid.TILE_IDS[next_tile_id]
		
		printt("gridplayermovement ", direction, next_coord, next_tile_type)
