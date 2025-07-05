class_name Battle
extends MarginContainer


signal ended(result)


const LEVEL_WEIGHT:float = 10.0

const TRACK_WIDTH:int = 600
const MIN_TARGET_WIDTH:int = 5
const MIN_TARGET_OFFSET:int = 80

const MOVE_SPEED_MIN:float = 100.0
const MOVE_SPEED_MAX:float = 500.0


enum Results { SUCCESS, RETRY, FAIL }


@export var result_scene:PackedScene


@onready var level:Label = %Level
@onready var track:Panel = %Track
@onready var stamina:ColorRect = %Stamina
@onready var attack:ColorRect = %Attack
@onready var input_container:MarginContainer = %InputContainer
@onready var input:ColorRect = %Input


var battle_level:int = 1
var player_stats:PlayerStats

var has_started:bool = false


func _ready() -> void:
	var player:Player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	player.input_component.accept_pressed.connect(_on_input_accept)
	
	_set_target_sizes()


func _process(delta: float) -> void:
	if has_started:
		var move_speed_weight = clamp(battle_level / float(PlayerStats.MAX_LEVEL), 0.0, 1.0)
		var move_speed:float = lerp(MOVE_SPEED_MIN, MOVE_SPEED_MAX, move_speed_weight)
		
		var current_margin: = input_container.get_theme_constant("margin_left")
		var next_margin:int = ceil(float(current_margin) + (move_speed * delta))
		input_container.add_theme_constant_override("margin_left", next_margin)
		
		if current_margin >= TRACK_WIDTH:
			_end_battle()


func _set_target_sizes() -> void:
	var weighted_level:float = battle_level * LEVEL_WEIGHT
	level.text = "Level %3d" % int(battle_level)
	
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


func _reset() -> void:
	has_started = false
	input_container.add_theme_constant_override("margin_left", 0)


func _on_input_accept() -> void:
	if not has_started:
		has_started = true
	else:
		_end_battle()


func _end_battle() -> void:
	has_started = false
	
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	
	var result:Results
	
	var input_position:int = input.position.x
	if input_position > attack.position.x and input_position < attack.position.x + attack.custom_minimum_size.x:
		# Within ATTACK range
		result = Results.SUCCESS
	
	elif input_position > stamina.position.x and input_position < stamina.position.x + stamina.custom_minimum_size.x:
		# Within STAMINA range
		# Do not free or emit ended, reset
		_reset()
		result = Results.RETRY
	
	else:
		# FAIL
		result = Results.FAIL
	
	ended.emit(result)
	
	var result_node = result_scene.instantiate()
	add_child(result_node)
	result_node.render(result)
	
	if [Results.SUCCESS, Results.FAIL].has(result):
		var player:Player = get_tree().get_first_node_in_group("player")
		player.input_component.accept_pressed.disconnect(_on_input_accept)
		# Leave it up for a second so the player can see where it stopped
		await get_tree().create_timer(1.0).timeout
		queue_free()
