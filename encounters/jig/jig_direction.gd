class_name JigDirection
extends TextureRect


const OFFSET_UP_Y: = -2
const OFFSET_DOWN_Y: = 2
const OFFSET_RIGHT_Y: = -1
const OFFSET_LEFT_Y: = 1

const OFFSET_MAP:Dictionary[Vector2, int] = {
	Vector2.UP: OFFSET_UP_Y,
	Vector2.DOWN: OFFSET_DOWN_Y,
	Vector2.RIGHT: OFFSET_RIGHT_Y,
	Vector2.LEFT: OFFSET_LEFT_Y
}

const MOVE_SPEED_MIN:float = 100.0
const MOVE_SPEED_MAX:float = 700.0


var level:int


func _ready():
	var offset = [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN].pick_random()
	position.y = OFFSET_MAP[offset]
	rotation = offset.angle()


func _process(delta):
	var move_speed_weight = clamp(level / float(PlayerStats.MAX_FATIGUE), 0.0, 1.0)
	var move_speed:float = lerp(MOVE_SPEED_MIN, MOVE_SPEED_MAX, move_speed_weight)
	
	position.x += ceil(move_speed * delta)
	
	if position.x >= Jig.TRACK_WIDTH:
		queue_free()
