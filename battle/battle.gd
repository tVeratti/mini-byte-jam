class_name Battle
extends MarginContainer


const LEVEL_WEIGHT:float = 10.0
const TRACK_WIDTH:int = 300
const MIN_TARGET_WIDTH:int = 5
const MIN_TARGET_OFFSET:int = 80


@onready var track:ColorRect = %Track
@onready var stamina:ColorRect = %Stamina
@onready var attack:ColorRect = %Attack
@onready var input_container:MarginContainer = %InputContainer


var level:int = 1
var player_stats:PlayerStats


func _ready() -> void:
	var player:Player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	player.input_component.accepted.connect(_on_input_accept)
	
	_set_target_sizes()


func _set_target_sizes() -> void:
	var weighted_level:float = level * LEVEL_WEIGHT
	var attack_percentage:float = float(player_stats.attack) / weighted_level
	var stamina_percentage:float = float(player_stats.stamina) / weighted_level
	
	var attack_width:int = clamp(
		MIN_TARGET_WIDTH,
		TRACK_WIDTH - MIN_TARGET_OFFSET,
		TRACK_WIDTH * attack_percentage)
	
	var stamina_width:int = clamp(
		MIN_TARGET_WIDTH,
		TRACK_WIDTH - MIN_TARGET_OFFSET,
		(TRACK_WIDTH * stamina_percentage) + attack_width)
	
	attack.custom_minimum_size.x = attack_width
	stamina.custom_minimum_size.x = stamina_width
	
	var random_offset:int = randi_range(
		MIN_TARGET_OFFSET,
		TRACK_WIDTH - max(attack_width, stamina_width))
	
	track.add_theme_constant_override("margin_left", random_offset)


func _on_input_accept() -> void:
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	grid.battle_ended.emit()
	
	queue_free()
