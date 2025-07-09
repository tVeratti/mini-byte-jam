@tool
class_name GridGenerator
extends Node


enum TileGroups { BUFF, UTILITY, ENCOUNTER, BLOCK, EMPTY, RARE }

const GOAL_MARGIN:float = 2
const NOISE_THRESHOLDS:Dictionary[float, TileGroups] = {
	0.46: TileGroups.BLOCK,
	0.50: TileGroups.RARE,
	0.60: TileGroups.EMPTY,
	0.90: TileGroups.BUFF,
	0.95: TileGroups.ENCOUNTER,
	1.00: TileGroups.UTILITY
}
const TILE_GROUP_MAP:Dictionary[TileGroups, Array] = {
	TileGroups.RARE: [Tile.Types.FATIGUE_REDUCTION, Tile.Types.HEAL],
	TileGroups.BLOCK: [Tile.Types.IMPASSABLE],
	TileGroups.BUFF: [
		Tile.Types.BUFF_ATTACK,
		Tile.Types.BUFF_MORALE],
	TileGroups.ENCOUNTER: [Tile.Types.BATTLE, Tile.Types.JIG],
	TileGroups.UTILITY: [Tile.Types.SCOUT],
	TileGroups.EMPTY: [Tile.Types.VISITED]
}


@export var grid_size:int = 100
@export var noise_texture:FastNoiseLite


var a_star: = AStarGrid2D.new()


func generate_tiles() -> Dictionary[Vector3, Tile.Types]:
	var tiles:Dictionary[Vector3, Tile.Types] = {}
	
	noise_texture.seed = randi_range(0, 999)
	
	# Prepare AStar to be used to check that the goal path is possible
	a_star = AStarGrid2D.new()
	a_star.region = Rect2i(0, 0, grid_size, grid_size)
	a_star.cell_size = Vector2(1, 1)
	a_star.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	a_star.update()
	
	var sorted_thresholds:Array = NOISE_THRESHOLDS.keys()
	sorted_thresholds.sort() # asc
	
	for x in range(grid_size):
		for y in range(grid_size):
			var coords: = Vector3(x, 0, y)
			var noise_value: = noise_texture.get_noise_2d(x, y)
			var normalized_value = remap(noise_value, -1.0, 1.0, 0.0, 1.0)
			var effect: = _get_type_from_noise(normalized_value, sorted_thresholds)
			tiles[coords] = effect #Tile.Types.IMPASSABLE #
			
			if effect == Tile.Types.IMPASSABLE:
				a_star.set_point_solid(Vector2i(x, y))
	
	return tiles


func generate_goal_coordinates(center:Vector3) -> Vector3i:
	var goal_direction:Vector3 = [
		Vector3.FORWARD,
		Vector3.BACK,
		Vector3.RIGHT,
		Vector3.LEFT,
		(Vector3.FORWARD + Vector3.RIGHT).normalized(),
		(Vector3.FORWARD + Vector3.LEFT).normalized(),
		(Vector3.BACK + Vector3.RIGHT).normalized(),
		(Vector3.BACK + Vector3.LEFT).normalized(),
	].pick_random()
	
	var goal_coordinates:Vector3i = center + (((grid_size / 2.0) - GOAL_MARGIN) * goal_direction)
	return goal_coordinates


func check_goal_path(center_coord:Vector3, goal_coord:Vector3, tiles:Dictionary) -> Dictionary:
	# Confirm that the goal can actually be reached
	var path: = a_star.get_point_path(
		Vector2i(goal_coord.x, goal_coord.z),
		Vector2i(center_coord.x, center_coord.z))
	
	for point in path:
		var coord_3d: = Vector3(point.x, 0, point.y)
		if tiles[coord_3d] == Tile.Types.IMPASSABLE:
			tiles[coord_3d] = Tile.Types.VISITED
	
	return tiles


func get_type_from_group(group:TileGroups) -> Tile.Types:
	return TILE_GROUP_MAP[group].pick_random()


func _get_type_from_noise(noise_value:float, sorted_thresholds:Array) -> Tile.Types:
	for threshold in sorted_thresholds:
		if noise_value <= threshold:
			var group:TileGroups = NOISE_THRESHOLDS[threshold]
			return get_type_from_group(group)
	
	return Tile.Types.VISITED
