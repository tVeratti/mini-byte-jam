class_name Battle
extends Encounter


const LEVEL_WEIGHT:float = 10.0

const TRACK_WIDTH:int = 600
const NEEDLE_WIDTH:int = 2
const MIN_TARGET_WIDTH:int = 5
const MIN_TARGET_OFFSET:int = 80

const MOVE_SPEED_MIN:float = 200.0
const MOVE_SPEED_MAX:float = 800.0


@export var result_scene:PackedScene


@onready var attack:ColorRect = %Attack
@onready var input:ColorRect = %Input
@onready var result_root:Control = %ResultRoot
@onready var target_container:MarginContainer = %TargetContainer
@onready var attack_value:Label = %AttackValue
@onready var fatigue_value:Label = %FatigueValue


var battle_level:int = 1
var player_stats:PlayerStats

var has_started:bool = false
var freeze_input:bool = false


func _ready() -> void:
	var player:Player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	player.input_component.accept_pressed.connect(_on_input_accept)
	player.input_component.direction_changed.connect(_on_direction_changed)
	
	render_labels()
	
	_set_target_sizes()


func render_labels() -> void:
	attack_value.text = "Attack: %s" % player_stats.attack
	fatigue_value.text = "Fatigue: %s" % player_stats.fatigue


func _process(delta: float) -> void:
	if has_started:
		var move_speed_weight = clamp(battle_level / float(PlayerStats.MAX_FATIGUE), 0.0, 1.0)
		var move_speed:float = lerp(MOVE_SPEED_MIN, MOVE_SPEED_MAX, move_speed_weight)
		
		input.position.x += move_speed * delta
		
		if input.position.x >= TRACK_WIDTH:
			_end_battle()


func _set_target_sizes() -> void:
	battle_level = player_stats.fatigue
	
	var weighted_level:float = battle_level * LEVEL_WEIGHT
	
	var attack_percentage:float = float(player_stats.attack) / weighted_level
	
	var attack_width:int = clamp(
		TRACK_WIDTH * attack_percentage,
		MIN_TARGET_WIDTH,
		TRACK_WIDTH - MIN_TARGET_OFFSET)
	
	attack.custom_minimum_size.x = attack_width
	
	var random_offset:int = randi_range(
		MIN_TARGET_OFFSET,
		TRACK_WIDTH - attack_width - 10)
	
	target_container.add_theme_constant_override("margin_left", random_offset)


func _reset() -> void:
	has_started = false
	input.position.x = 0


func _on_direction_changed(dir:Vector3) -> void:
	if not dir.is_zero_approx():
		_on_input_accept()


func _on_input_accept() -> void:
	if freeze_input: return
	
	if not has_started:
		has_started = true
	else:
		_end_battle()


func _end_battle() -> void:
	has_started = false
	freeze_input = true
	
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	
	var result:Results
	
	var input_position:int = input.position.x
	var attack_position_left:int = attack.position.x
	var attack_position_right:int = attack.position.x + attack.custom_minimum_size.x
	
	if input_position + NEEDLE_WIDTH >= attack_position_left and input_position - NEEDLE_WIDTH <= attack_position_right:
		# Within ATTACK range
		result = Results.SUCCESS
		
	else:
		# FAIL
		result = Results.FAIL
	
	var result_node = result_scene.instantiate()
	result_root.add_child(result_node)
	result_node.render(result)
	
	# Leave it up for a second so the player can see where it stopped
	await get_tree().create_timer(1.0).timeout
	ended.emit(result)
	queue_free()
