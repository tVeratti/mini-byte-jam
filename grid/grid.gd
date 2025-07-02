@tool
extends GridMap


const TILE_IDS:Dictionary[int, Tile.Types] = {
	0: Tile.Types.VISITED,
	1: Tile.Types.BUFF,
	2: Tile.Types.HEAL,
	3: Tile.Types.BATTLE,
	4: Tile.Types.SCOUT
}


@export_tool_button("Generate Tiles")
var button:Callable = generate_tiles


@onready var grid_generator:GridGenerator = %GridGenerator


func _ready():
	var tiles: = grid_generator.generate_tiles()


func generate_tiles() -> void:
	var tiles: = grid_generator.generate_tiles()
	for coord in tiles.keys():
		var type:Tile.Types = tiles[coord]
		set_cell_item(Vector3i(coord.x, 0, coord.y), TILE_IDS[type])
