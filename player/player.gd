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
@onready var player_notifications:PlayerNotifications = %PlayerNotifications


func _ready() -> void:
	coordinates_changed.connect(_on_coordinates_changed)


func _process(_delta):
	camera_3d.look_at(global_position)
	state_label.text = player_state_machine.state.name


func _on_coordinates_changed(coordinates:Vector3) -> void:
	player_stats.level_up()
	
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	var tile_type: = grid.tiles[coordinates]
	
	match(tile_type):
		Tile.Types.VISITED:
			pass
		Tile.Types.BUFF_ATTACK:
			player_stats.buff_attack(1)
		Tile.Types.BUFF_MORALE:
			player_stats.buff_morale(1)
		Tile.Types.HEAL:
			player_stats.heal(1.0) # TODO: Actual amount
		Tile.Types.SCOUT:
			grid.radius_scouted.emit(coordinates, 5, true)
		Tile.Types.BATTLE:
			pass
		Tile.Types.GOAL:
			pass
	
	grid.tile_entered.emit(coordinates)
