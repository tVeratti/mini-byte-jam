class_name GridGenerator
extends Node


const GRID_SIZE:int = 100
const NOISE_THRESHOLDS:Dictionary = {
	0.2: Tile.Effects.HEAL,
	0.6: Tile.Effects.BUFF,
	0.8: Tile.Effects.BATTLE,
	1.0: Tile.Effects.SCOUT
}



@export var noise_texture:TextureRect



func generate_tiles() -> Dictionary[Vector2, Tile.Effects]:
	var tiles:Dictionary[Vector2, Tile.Effects] = {}
	
	var noise:FastNoiseLite = noise_texture.texture.noise
	noise.seed = randi_range(0, 999)
	
	var sorted_thresholds:Array = NOISE_THRESHOLDS.keys()
	sorted_thresholds.sort() # ascending
	
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var coords: = Vector2(x, y)
			var noise_value: = noise.get_noise_2d(x, y)
			var effect: = _get_type_from_noise(noise_value, sorted_thresholds)
			tiles[coords] = effect
	
	return tiles


func _get_type_from_noise(noise_value:float, sorted_thresholds:Array) -> Tile.Effects:
	for threshold in sorted_thresholds:
		if noise_value <= threshold:
			return NOISE_THRESHOLDS[threshold]
	
	return Tile.Effects.BUFF
