@tool
class_name Grid
extends GridMap


signal tile_entered(coordinates:Vector3)
signal radius_scouted(center:Vector3, radius:int, show_goal_direction:bool)

signal encounter_started(type:Encounter.Types, level:int)
signal encounter_ended(type:Encounter.Types, result:Battle.Results)



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
	8: Tile.Types.FATIGUE_REDUCTION,
	9: Tile.Types.JIG
}

const REVEAL_DELAY:float = 0.01


@export var tile_scene:PackedScene
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
	var center:int = grid_generator.grid_size / 2.0
	var center_coord: = Vector3(center, 0, center)
	goal_tile_coordinates = grid_generator.generate_goal_coordinates(center_coord)
	
	# Make goal adjacent tiles as encounter types
	var goal_adjacent = [Vector3.RIGHT, Vector3.FORWARD, Vector3.LEFT, Vector3.BACK]
	for adj in goal_adjacent:
		tiles[goal_tile_coordinates + adj] = grid_generator.get_type_from_group(GridGenerator.TileGroups.ENCOUNTER)
	
	# Check that there is a valid path to the goal
	tiles = grid_generator.check_goal_path(center_coord, goal_tile_coordinates, tiles)
	
	# Set the goal tile value
	tiles[goal_tile_coordinates] = Tile.Types.GOAL
	
	if Engine.is_editor_hint():
		for coord in tiles.keys():
			var type:Tile.Types = tiles[coord]
			set_cell_item(coord, type)


func show_tiles(center:Vector3, radius:int) -> void:
	# Add minimum range to compensate for current tile/half range
	radius += 2
	
	var revealed_tiles:Array = []
	
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
					var node_name:String = var_to_str(coordinates)
					
					if not has_node(node_name):
						var tile:Tile = tile_scene.instantiate() 
						tile.name = node_name
						add_child(tile)
						tile.global_position = map_to_local(coordinates) - Vector3(0, 1, 0)
						tile.type = tile_type
						revealed_tiles.append([abs(x) + abs(y), tile])
	
	# Sort the tiles by distance so they animate reveal in that order
	revealed_tiles.sort_custom(func(a, b):
		return a[0] < b[0])
	
	for tile in revealed_tiles:
		var distance:float = tile[0]
		var tile_node:Tile = tile[1]
		
		var delay:float = REVEAL_DELAY * distance
		await get_tree().create_timer(delay).timeout
		tile_node.animate_in()


func _on_tile_entered(coordinates:Vector3) -> void:
	var tile_type:Tile.Types = tiles[coordinates]
	match(tile_type):
		Tile.Types.BATTLE:
			encounter_started.emit(Encounter.Types.BATTLE, 1)
		Tile.Types.JIG:
			encounter_started.emit(Encounter.Types.JIG, 1)
		Tile.Types.GOAL:
			goal_entered.emit()
	
	radius_scouted.emit(coordinates, 1, false)
	
	# Set the current location to `VISITED` so it doesn't trigger again later
	var tile:Tile = get_node(var_to_str(coordinates))
	tile.type = Tile.Types.VISITED
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
		arrow.modulate = Color("#ccffa4")
		arrow.look_at(map_to_local(goal_tile_coordinates))
		arrow.rotation_degrees.x = 90.0
		arrow.rotation_degrees.y += 180
	
	show_tiles(center, radius)
