class_name Map
extends Node


@export var battle_scene:PackedScene
@export var jig_scene:PackedScene
@export var goal_window_scene:PackedScene
@export var end_window_scene:PackedScene


var load_player_stats:PlayerStats


@onready var interface:CanvasLayer = %Interface
@onready var grid:Grid = %Grid
@onready var player:Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	grid.generate_tiles()
	
	# Center the player within the grid
	var center_i: = int(grid.grid_generator.grid_size / 2.0)
	var center_coord: = Vector3(center_i, 0, center_i)
	var local_pos: = grid.map_to_local(center_coord)
	player.global_position = grid.to_global(local_pos) + Vector3(0, 0.5, 0)
	grid.tile_entered.emit(center_coord)
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	grid.encounter_started.connect(_on_encounter_started)
	grid.goal_entered.connect(_on_goal_entered)
	player.player_stats.health_zero.connect(_on_player_health_zero)


func _on_encounter_started(type:Encounter.Types, level:int) -> void:
	match(type):
		Encounter.Types.BATTLE:
			_on_battle_started(level)
		Encounter.Types.JIG:
			_on_jig_started(level)


func _on_battle_started(level:int) -> void:
	var battle_node:Battle = battle_scene.instantiate()
	battle_node.ended.connect(_on_encounter_ended.bind(Encounter.Types.BATTLE))
	interface.add_child(battle_node)


func _on_jig_started(level:int) -> void:
	var jig_node:Jig = jig_scene.instantiate()
	jig_node.ended.connect(_on_encounter_ended.bind(Encounter.Types.JIG))
	interface.add_child(jig_node)


func _on_encounter_ended(result:Encounter.Results, type:Encounter.Types) -> void:
	grid.encounter_ended.emit(type, result)


func _on_goal_entered() -> void:
	var goal_window = goal_window_scene.instantiate()
	interface.add_child(goal_window)


func _on_player_health_zero() -> void:
	var end_window = end_window_scene.instantiate()
	interface.add_child(end_window)
