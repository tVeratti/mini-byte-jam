@tool
class_name GridGenerator
extends Node


enum TileGroups { BUFF, UTILITY, DANGER, BLOCK, EMPTY }

const GOAL_MARGIN:float = 2
const NOISE_THRESHOLDS:Dictionary[float, TileGroups] = {
	0.50: TileGroups.BLOCK,
	0.60: TileGroups.EMPTY,
	0.80: TileGroups.BUFF,
	0.92: TileGroups.DANGER,
	1.00: TileGroups.UTILITY
}
const TILE_GROUP_MAP:Dictionary[TileGroups, Array] = {
	TileGroups.BLOCK: [Tile.Types.IMPASSABLE],
	TileGroups.BUFF: [
		Tile.Types.BUFF_ATTACK,
		Tile.Types.BUFF_MORALE,
		Tile.Types.FATIGUE_REDUCTION],
	TileGroups.DANGER: [Tile.Types.BATTLE],
	TileGroups.UTILITY: [Tile.Types.HEAL, Tile.Types.SCOUT],
	TileGroups.EMPTY: [Tile.Types.VISITED]
}


@export var grid_size:int = 100
@export var noise_texture:FastNoiseLite


func generate_tiles() -> Dictionary[Vector3, Tile.Types]:
	var tiles:Dictionary[Vector3, Tile.Types] = {}
	
	noise_texture.seed = randi_range(0, 999)
	
	var sorted_thresholds:Array = NOISE_THRESHOLDS.keys()
	sorted_thresholds.sort() # asc
	
	for x in range(grid_size):
		for y in range(grid_size):
			var coords: = Vector3(x, 0, y)
			var noise_value: = noise_texture.get_noise_2d(x, y)
			var normalized_value = remap(noise_value, -1.0, 1.0, 0.0, 1.0)
			var effect: = _get_type_from_noise(normalized_value, sorted_thresholds)
			tiles[coords] = effect
	
	return tiles


func generate_goal_coordinates(center:Vector3) -> Vector3:
	var goal_direction:Vector3 = [
		Vector3.FORWARD,
		Vector3.BACK,
		Vector3.RIGHT,
		Vector3.LEFT
	].pick_random()
	
	var goal_coordinates:Vector3 = center + (((grid_size / 2.0) - GOAL_MARGIN) * goal_direction)
	return goal_coordinates


func _get_type_from_noise(noise_value:float, sorted_thresholds:Array) -> Tile.Types:
	for threshold in sorted_thresholds:
		if noise_value <= threshold:
			var group:TileGroups = NOISE_THRESHOLDS[threshold]
			return TILE_GROUP_MAP[group].pick_random()
	
	return Tile.Types.VISITED
