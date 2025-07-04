class_name PlayerStats
extends Node


signal stats_changed
signal health_zero


const DEFAULT_HEALTH_MAX:int = 5


var attack:int = 1.0
var stamina:int = 1.0

var health_max:int = DEFAULT_HEALTH_MAX
var health_current:int = DEFAULT_HEALTH_MAX


func take_damage(amount:float) -> void:
	health_current -= amount
	
	stats_changed.emit()
	
	if health_current <= 0:
		health_zero.emit()


func heal(amount:int) -> void:
	health_current = min(health_current + amount, health_max)
	stats_changed.emit()


func buff_attack(amount:int) -> void:
	attack += amount
	stats_changed.emit()


func buff_stamina(amount:int) -> void:
	stamina += amount
	stats_changed.emit()
