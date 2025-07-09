class_name Tile
extends Node3D


enum Types { VISITED, BUFF_ATTACK, BUFF_MORALE, HEAL, BATTLE, SCOUT, GOAL, IMPASSABLE, FATIGUE_REDUCTION, JIG }


const ICON_BATTLE_UID:String = "uid://dae03ox6o0lxn"
const ICON_BUFF_ATTACK_UID:String = "uid://cdtuar3vyptkk"
const ICON_BUFF_MORALE_UID:String = "uid://cs6mjv22njc1d"
const ICON_HEAL_UID:String = "uid://cmatcvxlnlqyf"
const ICON_SCOUT_UID:String = "uid://cyaddnhljuwx2"
const ICON_FATIGUE_UID:String = "uid://gvrnvcj61ihu"
const ICON_JIG_UID:String = "uid://bfj3cwx5kspn8"
const ICON_GOAL_UID:String = "uid://broyicinkbdrh"

const SHINE_SHADER_UID:String = "uid://cy364oju0514s"


const ICON_MAP:Dictionary[int, Texture] = {
	Types.BATTLE: preload(ICON_BATTLE_UID),
	Types.BUFF_ATTACK: preload(ICON_BUFF_ATTACK_UID),
	Types.BUFF_MORALE: preload(ICON_BUFF_MORALE_UID),
	Types.HEAL: preload(ICON_HEAL_UID),
	Types.SCOUT: preload(ICON_SCOUT_UID),
	Types.FATIGUE_REDUCTION: preload(ICON_FATIGUE_UID),
	Types.JIG: preload(ICON_JIG_UID),
	Types.GOAL: preload(ICON_GOAL_UID)
}

const COLOR_MAP:Dictionary[int, Color] = {
	Types.VISITED: Palette.TEAL_01,
	Types.BUFF_ATTACK: Palette.TEAL_04,
	Types.BUFF_MORALE: Palette.TEAL_04,
	Types.HEAL: Palette.TEAL_05,
	Types.FATIGUE_REDUCTION: Palette.TEAL_05,
	Types.SCOUT: Palette.YELLOW_01,
	Types.BATTLE: Palette.BLUE_03,
	Types.JIG:  Palette.BLUE_03,
	Types.GOAL: Palette.YELLOW_02
}


@export var rock_meshes:Array[Mesh] = []


var type:Types : set = _set_type


@onready var mesh_instance_3d:MeshInstance3D = $MeshInstance3D
@onready var icon_sprite_3d:Sprite3D = $Icon


func animate_in() -> void:
	var tween: = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "global_position:y", 1, 0.5).as_relative()


func _set_type(value:Types) -> void:
	type = value
	
	if ICON_MAP.has(type):
		icon_sprite_3d.texture = ICON_MAP[type]
	else:
		icon_sprite_3d.hide()
	
	if COLOR_MAP.has(type):
		_set_color(COLOR_MAP[type])
	
	if type == Types.IMPASSABLE:
		mesh_instance_3d.mesh = rock_meshes.pick_random()
		_set_color(Color.DIM_GRAY.lightened(randf_range(0.0, 0.5)))
		mesh_instance_3d.rotation_degrees.y = randf_range(0, 360)
	elif type == Types.GOAL:
		var shine_pass:ShaderMaterial = ShaderMaterial.new()
		shine_pass.shader = load(SHINE_SHADER_UID)
		mesh_instance_3d.get_active_material(0).next_pass = shine_pass


func _set_color(value:Color) -> void:
	mesh_instance_3d.get_active_material(0).albedo_color = value
	icon_sprite_3d.modulate = value.lightened(0.2)
