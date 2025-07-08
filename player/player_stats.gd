class_name PlayerStats
extends Node


signal stats_changed
signal health_zero


const MAX_HEALTH:int = 5
const MAX_FATIGUE:int = 100
const MAX_ATTACK:int = 100
const MAX_MORALE:int = 100


const FATIGUE_REDUCTION_MULTIPLIER:float = 0.5


var fatigue:int = 1
var attack:int = 1
var morale:int = 1

var health_max:int = MAX_HEALTH
var health_current:int = MAX_HEALTH


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
	attack = min(attack + amount, MAX_ATTACK)
	stats_changed.emit()
	notifications.render("+%s Attack" % amount)


func buff_morale(amount:int) -> void:
	morale = min(morale + amount, MAX_MORALE)
	stats_changed.emit()
	notifications.render("+%s Morale" % amount)


func increase_fatigue() -> void:
	fatigue = min(fatigue + 1, MAX_FATIGUE)
	stats_changed.emit()


func reduce_fatigue(percentage:float = FATIGUE_REDUCTION_MULTIPLIER) -> void:
	var amount:int = ceil(fatigue * percentage)
	fatigue = max(fatigue - amount, 0)
	stats_changed.emit()
	notifications.render("-%s Fatigue" % amount)
