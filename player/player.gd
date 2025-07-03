class_name Player
extends MeshInstance3D


signal direction_intent_changed(direction:Vector3)
signal coordinates_changed(coordinates:Vector3)


@onready var input_component:InputComponent = $InputComponent
@onready var player_stats:PlayerStats = $PlayerStats
@onready var player_state_machine:PlayerStateMachine = %PlayerStateMachine
@onready var player_direction_intent:PlayerDirectionIntent = %PlayerDirectionIntent
@onready var state_label:Label3D = %StateLabel
@onready var camera_3d:Camera3D = $Camera3D


var steps_taken:int = 0


func _ready() -> void:
	coordinates_changed.connect(_on_coordinates_changed)


func _process(_delta):
	camera_3d.look_at(global_position)
	state_label.text = player_state_machine.state.name


func _on_coordinates_changed(coordinates:Vector3) -> void:
	steps_taken += 1
	
	var grid:TileGrid = get_tree().get_first_node_in_group("tile_grid")
	var tile_type: = grid.tiles[coordinates]
	
	match(tile_type):
		Tile.Types.VISITED:
			print("visited")
		Tile.Types.BUFF_ATTACK:
			print("+ attack")
			player_stats.attack += 1
		Tile.Types.BUFF_STAMINA:
			print("+ stamina")
			player_stats.stamina += 1
		Tile.Types.HEAL:
			print("heal")
			player_stats.heal(1.0) # TODO: Actual amount
		Tile.Types.SCOUT:
			print("scout")
			grid.radius_scouted.emit(coordinates, 3)
			pass # TODO: Reveal nearby tile types
		Tile.Types.BATTLE:
			print("battle")
			pass # TODO: Open skillcheck UI
	
	grid.tile_entered.emit(coordinates)
