class_name Jig
extends Encounter


const LEVEL_WEIGHT:float = 10.0

const TRACK_WIDTH:int = 600
const MAX_MOVES:int = 4


@export var jig_direction_scene:PackedScene
@export var result_scene:PackedScene


@onready var result_root:Control = %ResultRoot
@onready var moves_root = %MovesRoot


var player_stats:PlayerStats

var has_started:bool = false
var freeze_input:bool = false

var move_index:int = 0
var player:Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	player.input_component.accept_pressed.connect(_on_input_accept)


func _process(delta: float) -> void:
	if has_started:
		pass


func _on_input_accept() -> void:
	if freeze_input: return
	
	if not has_started:
		has_started = true
	else:
		_end_jig()


func _add_direction_jig_node() -> void:
	var jig_node:JigDirection = jig_direction_scene.instantiate()
	jig_node.level = player_stats.fatigue
	moves_root.add_child(jig_node)


func _end_jig() -> void:
	has_started = false
	freeze_input = true
	
	var grid:Grid = get_tree().get_first_node_in_group("tile_grid")
	
	var result:Results
	
	var result_node = result_scene.instantiate()
	result_root.add_child(result_node)
	result_node.render(result)
	
	# Leave it up for a second so the player can see where it stopped
	await get_tree().create_timer(1.0).timeout
	ended.emit(result)
	
	queue_free()


func _on_timer_timeout():
	_add_direction_jig_node()
