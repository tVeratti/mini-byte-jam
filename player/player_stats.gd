class_name PlayerStats
extends Node


signal stats_changed
signal health_zero


const MAX_HEALTH:int = 5
const MAX_FATIGUE:int = 200


const FATIGUE_REDUCTION_MULTIPLIER:float = 0.5
const FATIGUE_PER_TREASURE:float = 1.0


var health_max:int = MAX_HEALTH
var health_current:int = MAX_HEALTH

# Encounter Stats
var fatigue:int = 1
var attack:int = 5
var morale:int = 5

# Fun Stats
var battles_won:int = 0
var jigs_won:int = 0
var treasures_found:int = 0
var nautical_miles_traveled:int = 0


var notifications:PlayerNotifications


func _ready() -> void:
	if is_instance_valid(owner):
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
	attack = attack + amount
	stats_changed.emit()
	notifications.render("+%s Attack" % amount)


func buff_morale(amount:int) -> void:
	morale = morale + amount
	stats_changed.emit()
	notifications.render("+%s Morale" % amount)


func increase_fatigue() -> void:
	var multiplier:float = max(1.0, float(treasures_found) * FATIGUE_PER_TREASURE)
	var amount:int = ceil(1.0 * multiplier)
	fatigue = min(fatigue + amount, MAX_FATIGUE)
	stats_changed.emit()


func reduce_fatigue(percentage:float = FATIGUE_REDUCTION_MULTIPLIER) -> void:
	var amount:int = ceil(fatigue * percentage)
	fatigue = max(fatigue - amount, 0)
	stats_changed.emit()
	notifications.render("-%s Fatigue" % amount)
