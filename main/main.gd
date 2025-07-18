extends Node3D


# THEME: Choice

# Grid:
# Every tile adjacent to you (not diagonal) lights up as an option
# Procedural map dictates what each tile is at the start of game
# Choose a tile to move on to and activate its effect
# Tile Effects:
# - Stat increase
# - Heal
# - Battle (Skill challenge)
# - Reveal tile effects in radius of n

# The Goal:
# There is a large "Escape" tile you can see from any distance.
# You want to get to that tile without dying along the way.
# Battle tiles get harder the closer to get to the escape.

# Battles:
# Skill challenge that is easier/harder based on stat diff
# Bar with small target area, need to hit input when dot is within target area
# Target area is bigger if your attack is higher
# Secondary target area around that which is bigger if your morale is high
# If you hit the secondary target area, you try again
# If you have higher stats than the skill challenge, it should be pretty easy
# If you fail, you take damage (equal to the diff??)

# Stats:
# - Attack
# - Morale
# - Health


@onready var player:Player = %Player
@onready var scene_root:Node3D = %SceneRoot


func _ready() -> void:
	player.process_mode = Node.PROCESS_MODE_DISABLED
	SceneManager.main_root = scene_root
	
	AudioManager.play_audio.emit(load("uid://dsfc732mmff8n"), -20.0, false)
