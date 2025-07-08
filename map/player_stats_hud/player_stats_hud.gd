extends Control


@onready var player:Player = get_tree().get_first_node_in_group("player")

@onready var health:ProgressBar = %HealthProgress
@onready var morale:ProgressBar = %MoraleProgress
@onready var attack:ProgressBar = %AttackProgress
@onready var fatigue:ProgressBar = %FatigueProgress


func _ready() -> void:
	render()
	player.player_stats.stats_changed.connect(_on_stats_changed)


func render() -> void:
	var stats: = player.player_stats
	
	var fatigue_value:float = stats.fatigue
	
	health.value = float(stats.health_current) / float(stats.health_max)
	morale.value = stats.morale / fatigue_value
	attack.value = stats.attack / fatigue_value
	fatigue.value = fatigue_value / PlayerStats.MAX_FATIGUE


func _on_stats_changed() -> void:
	render()
