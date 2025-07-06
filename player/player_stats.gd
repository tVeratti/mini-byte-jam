class_name PlayerStats
extends Node


signal stats_changed
signal health_zero


const DEFAULT_HEALTH_MAX:int = 5
const MAX_LEVEL:int = 500


var level:int = 1

var attack:int = 1.0
var morale:int = 1.0

var health_max:int = DEFAULT_HEALTH_MAX
var health_current:int = DEFAULT_HEALTH_MAX


var notifications:PlayerNotifications


func _ready() -> void:
	await owner.ready
	notifications = owner.player_notifications


func take_damage(amount:int) -> void:
	health_current -= amount
	stats_changed.emit()
	notifications.render("-%s Health" % amount)
	
	if health_current <= 0:
		health_zero.emit()


func heal(amount:int) -> void:
	health_current = min(health_current + amount, health_max)
	stats_changed.emit()
	notifications.render("+%s Health" % amount)


func buff_attack(amount:int) -> void:
	attack += amount
	stats_changed.emit()
	notifications.render("+%s Attack" % amount)


func buff_morale(amount:int) -> void:
	morale += amount
	stats_changed.emit()
	notifications.render("+%s Morale" % amount)


func level_up() -> void:
	level = min(level + 1, MAX_LEVEL)
	stats_changed.emit()
