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
@onready var boat:Node3D = %Boat


func _ready() -> void:
	coordinates_changed.connect(_on_coordinates_changed)


func _process(_delta):
	camera_3d.look_at(global_position)
	state_label.text = player_state_machine.state.name


func _on_coordinates_changed(coordinates:Vector3) -> void:
	player_stats.increase_fatigue()
	
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
			player_stats.heal(1)
		Tile.Types.SCOUT:
			grid.radius_scouted.emit(coordinates, 5, true)
		Tile.Types.BATTLE:
			pass
		Tile.Types.GOAL:
			player_stats.reduce_fatigue()
		Tile.Types.FATIGUE_REDUCTION:
			player_stats.reduce_fatigue(0.1)
	
	grid.tile_entered.emit(coordinates)
