extends Control


@onready var player:Player = get_tree().get_first_node_in_group("player")

@onready var health:Label = %Health
@onready var morale:Label = %Morale
@onready var attack:Label = %Attack
@onready var fatigue: Label = %Fatigue


func _ready() -> void:
	render()
	player.player_stats.stats_changed.connect(_on_stats_changed)


func render() -> void:
	var stats: = player.player_stats
	
	health.text = "Health %s/%s" % [stats.health_current, stats.health_max]
	morale.text = "Morale %s" % stats.morale
	attack.text = "Attack %s" % stats.attack
	fatigue.text = "Fatigue %s" % stats.fatigue


func _on_stats_changed() -> void:
	render()
