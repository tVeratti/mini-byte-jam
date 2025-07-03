@tool
class_name TileGrid
extends GridMap

signal tile_entered(coordinates:Vector3)
signal radius_scouted(center:Vector3, radius:int)


const TILE_IDS:Dictionary[int, Tile.Types] = {
	0: Tile.Types.VISITED,
	1: Tile.Types.BUFF_ATTACK,
	2: Tile.Types.BUFF_STAMINA,
	3: Tile.Types.HEAL,
	4: Tile.Types.BATTLE,
	5: Tile.Types.SCOUT
}


@export_tool_button("Generate Tiles")
var button:Callable = generate_tiles


var tiles:Dictionary[Vector3, Tile.Types] = {}


@onready var grid_generator:GridGenerator = %GridGenerator


func _ready() -> void:
	tile_entered.connect(_on_tile_entered)
	radius_scouted.connect(_on_radius_scouted)


func generate_tiles() -> void:
	clear()
	
	tiles = grid_generator.generate_tiles()
	#for coord in tiles.keys():
		#var type:Tile.Types = tiles[coord]
		# Start hidden (set as nothing)
		#set_cell_item(Vector3i(coord.x, 0, coord.y), -1)


func _show_tiles(center:Vector3, radius:int) -> void:
	var directions = [
		Vector3.FORWARD,
		Vector3.BACK,
		Vector3.RIGHT,
		Vector3.LEFT,
		# Diagonal Directions
		Vector3.FORWARD + Vector3.LEFT,
		Vector3.FORWARD + Vector3.RIGHT,
		Vector3.BACK + Vector3.LEFT,
		Vector3.BACK + Vector3.RIGHT ]
	
	for r in range(radius):
		for direction in directions:
			var coordinates:Vector3 = center + (direction * (r + 1))
			var tile_type:Tile.Types = tiles[coordinates]
			var tile_id:int = TILE_IDS[tile_type]
			
			set_cell_item(coordinates, tile_id)


func _on_tile_entered(coordinates:Vector3) -> void:
	# TODO: Resolve tile effect
	
	radius_scouted.emit(coordinates, 1)
	
	# Set the current location to `VISITED` so it doesn't trigger again later
	var visited_id: = TILE_IDS[Tile.Types.VISITED]
	set_cell_item(coordinates, visited_id)
	tiles[coordinates] = Tile.Types.VISITED
	


func _on_radius_scouted(center:Vector3, radius:int) -> void:
	_show_tiles(center, radius)
