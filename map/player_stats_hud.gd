extends Control


@export var player:Player


@onready var health:Label = %Health
@onready var stamina:Label = %Stamina
@onready var attack:Label = %Attack
@onready var level: Label = %Level


func _ready() -> void:
	await owner.ready
	
	player.player_stats.stats_changed.connect(_on_stats_changed)


func render() -> void:
	var stats: = player.player_stats
	
	health.text = "Health %s/%s" % [stats.health_current, stats.health_max]
	stamina.text = "Stamina %s" % stats.stamina
	attack.text = "Attack %s" % stats.attack
	level.text = "Level %03d" % stats.level


func _on_stats_changed() -> void:
	render()
