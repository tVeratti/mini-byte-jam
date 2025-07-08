class_name JigDirection
extends TextureRect


signal enter_range
signal exit_range


const OFFSET_UP_Y: = -2
const OFFSET_DOWN_Y: = 2
const OFFSET_RIGHT_Y: = -1
const OFFSET_LEFT_Y: = 1

const NODE_WIDTH:float = 80.0
const RANGE_MARGIN:float = 20.0

const OFFSET_MAP:Dictionary[Vector2, int] = {
	Vector2.UP: OFFSET_UP_Y,
	Vector2.DOWN: OFFSET_DOWN_Y,
	Vector2.RIGHT: OFFSET_RIGHT_Y,
	Vector2.LEFT: OFFSET_LEFT_Y
}

const MOVE_SPEED_MIN:float = 100.0
const MOVE_SPEED_MAX:float = 700.0


var player_stats:PlayerStats
var direction:Vector2

var within_range:bool = false
var is_animating:bool = false


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	player_stats = player.player_stats
	
	scale = Vector2.ZERO
	direction = [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN].pick_random()
	position.y = OFFSET_MAP[direction] * -20
	rotation = Vector2.UP.rotated(direction.angle()).angle()
	
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)


func _process(delta):
	if is_animating:
		return
	
	var move_speed_weight = clamp(player_stats.fatigue / float(PlayerStats.MAX_FATIGUE), 0.0, 1.0)
	var move_speed:float = lerp(MOVE_SPEED_MIN, MOVE_SPEED_MAX, move_speed_weight)
	
	position.x += ceil(move_speed * delta)
	
	if not within_range:
		if position.x + NODE_WIDTH >= Jig.TRACK_WIDTH - RANGE_MARGIN:
			modulate.a = 1.0
			within_range = true
			enter_range.emit(self)
		
	elif position.x >= Jig.TRACK_WIDTH:
		exit_range.emit(self)
		animate_fail()


func animate_success() -> void:
	is_animating = true
	scale = Vector2(2, 2)
	modulate = Color("#02a676")
	
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "position:y", -100, 0.2).as_relative()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)


func animate_fail() -> void:
	is_animating = true
	modulate = Color.RED
	
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "position:y", 100, 0.2).as_relative()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
