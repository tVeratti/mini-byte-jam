class_name Jig
extends Encounter


const LEVEL_WEIGHT:float = 10.0

const TRACK_WIDTH:int = 600
const MIN_MOVES:int = 4
const MAX_MOVES:int = 12
const TIMER_SPEED:float = 1.0


@export var jig_direction_scene:PackedScene
@export var result_scene:PackedScene


var player_stats:PlayerStats

var has_started:bool = false
var freeze_input:bool = false

var max_moves:int = MAX_MOVES
var success_count:int = 0
var move_count: int = 0
var player:Player

var within_range:Array[JigDirection] = []


@onready var result_root:Control = %ResultRoot
@onready var moves_root = %MovesRoot
@onready var timer:Timer = %Timer
@onready var morale_value:Label = %MoraleValue
@onready var fatigue_value:Label = %FatigueValue


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	var morale_percentage:float = float(player_stats.morale) / float(PlayerStats.MAX_MORALE)
	max_moves = clamp(morale_percentage * MAX_MOVES, MIN_MOVES, MAX_MOVES)
	
	player.input_component.accept_pressed.connect(_on_input_accept)
	player.input_component.direction_changed.connect(_on_direction_changed)
	
	render_labels()


func render_labels() -> void:
	morale_value.text = "Morale: %s" % player_stats.morale
	fatigue_value.text = "Fatigue: %s" % player_stats.fatigue


func _on_input_accept() -> void:
	if freeze_input: return
	
	if not has_started:
		has_started = true
		_add_direction_jig_node()
		timer.start()


func _add_direction_jig_node() -> void:
	var morale_fatigue_percentage:float = float(player_stats.morale) / float(player_stats.fatigue)
	timer.wait_time = clamp(morale_fatigue_percentage * TIMER_SPEED, 0.1, TIMER_SPEED)
	
	move_count += 1
	
	var jig_node:JigDirection = jig_direction_scene.instantiate()
	jig_node.enter_range.connect(_on_jig_enter_range)
	jig_node.exit_range.connect(_on_jig_exit_range)
	moves_root.add_child(jig_node)


func _on_direction_changed(direction:Vector3) ->void:
	if has_started and not freeze_input:
		if direction.is_zero_approx(): return
		
		var has_one_match:bool = false
		var direction_2d: = Vector2(direction.x, direction.z)
		for jig_node in within_range:
			if is_instance_valid(jig_node) and jig_node.direction.is_equal_approx(direction_2d):
				jig_node.animate_success()
				within_range.erase(jig_node)
				has_one_match = true
				
				success_count += 1
				if success_count >= max_moves:
					_end_jig(Encounter.Results.SUCCESS)
				
				break
	
		if not has_one_match:
			# No match found, so it drain fatigue
			player_stats.increase_fatigue()
			render_labels()
		
	elif not direction.is_zero_approx():
		_on_input_accept()


func _end_jig(result:Encounter.Results) -> void:
	has_started = false
	freeze_input = true
	
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	
	var result_node = result_scene.instantiate()
	result_root.add_child(result_node)
	result_node.render(result)
	
	# Leave it up for a second so the player can see where it stopped
	await get_tree().create_timer(1.0).timeout
	ended.emit(result)
	
	queue_free()


func _on_timer_timeout():
	if move_count >= max_moves:
		return
	
	_add_direction_jig_node()


func _on_jig_enter_range(jig_node:JigDirection) -> void:
	within_range.append(jig_node)


func _on_jig_exit_range(jig_node:JigDirection) -> void:
	_end_jig(Encounter.Results.FAIL)
