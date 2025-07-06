@tool
class_name Grid
extends GridMap


signal tile_entered(coordinates:Vector3)
signal radius_scouted(center:Vector3, radius:int, show_goal_direction:bool)

signal battle_started(level:int)
signal battle_ended(result:Battle.Results)

signal goal_entered


const SCOUT_ID:int = 5
const GOAL_ID:int = 6
const TILE_IDS:Dictionary[int, Tile.Types] = {
	0: Tile.Types.VISITED,
	1: Tile.Types.BUFF_ATTACK,
	2: Tile.Types.BUFF_MORALE,
	3: Tile.Types.HEAL,
	4: Tile.Types.BATTLE,
	5: Tile.Types.SCOUT,
	6: Tile.Types.GOAL,
	7: Tile.Types.IMPASSABLE,
	8: Tile.Types.FATIGUE_REDUCTION
}


@export var scout_decal_texture:Texture

@export_tool_button("Generate Tiles")
var button:Callable = generate_tiles


var tiles:Dictionary[Vector3, Tile.Types] = {}
var goal_tile_coordinates:Vector3


@onready var grid_generator:GridGenerator = %GridGenerator


func _ready() -> void:
	tile_entered.connect(_on_tile_entered)
	radius_scouted.connect(_on_radius_scouted)


func generate_tiles() -> void:
	clear()
	
	tiles = grid_generator.generate_tiles()
	
	# Set Goal tile
	var center = grid_generator.grid_size / 2.0
	goal_tile_coordinates = grid_generator.generate_goal_coordinates(Vector3(center, 0, center))
	tiles[goal_tile_coordinates] = Tile.Types.GOAL
	
	#for coord in tiles.keys():
		#var type:Tile.Types = tiles[coord]
		#set_cell_item(coord, type)


func show_tiles(center:Vector3, radius:int) -> void:
	# Add minimum range to compensate for current tile/half range
	radius += 2
	
	for i in range(radius):
		var x: = i - int(radius / 2.0)
		
		for j in range(radius):
			var y: = j - int(radius / 2.0)
			
			var distance: = absi(x) + absi(y)
			if distance <= radius:
				var direction: = Vector3(x, 0, y)
				var coordinates:Vector3 = center + direction
				if tiles.has(coordinates):
					var tile_type:Tile.Types = tiles[coordinates]
					var tile_id:int = TILE_IDS[tile_type]
					
					set_cell_item(coordinates, tile_id)


func _on_tile_entered(coordinates:Vector3) -> void:
	var tile_type:Tile.Types = tiles[coordinates]
	match(tile_type):
		Tile.Types.BATTLE:
			battle_started.emit(1)
		Tile.Types.GOAL:
			goal_entered.emit()
	
	radius_scouted.emit(coordinates, 1, false)
	
	# Set the current location to `VISITED` so it doesn't trigger again later
	var visited_id: = TILE_IDS[Tile.Types.VISITED]
	set_cell_item(coordinates, visited_id)
	tiles[coordinates] = Tile.Types.VISITED


func _on_radius_scouted(center:Vector3, radius:int, show_goal_direction:bool) -> void:
	if show_goal_direction:
		# Show decal in direction of GOAL tile
		var tile_mesh: = mesh_library.get_item_mesh(SCOUT_ID)
		var tile_half_height: = (tile_mesh.get_aabb().size.y / 2.0)
		var arrow_offset: = Vector3(0, tile_half_height + 0.1, 0)
		
		var arrow = Sprite3D.new()
		add_child(arrow)
		arrow.texture = scout_decal_texture
		arrow.global_position = map_to_local(center) + arrow_offset
		arrow.look_at(map_to_local(goal_tile_coordinates))
		arrow.rotation_degrees.x = 90.0
		arrow.rotation_degrees.y += 180
	
	show_tiles(center, radius)
