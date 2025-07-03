class_name PlayerStats
extends Node


signal health_zero


const DEFAULT_HEALTH_MAX:float = 5.0


var attack:float = 1.0
var stamina:float = 1.0

var health_max:float = DEFAULT_HEALTH_MAX
var health_current:float = DEFAULT_HEALTH_MAX


func take_damage(amount:float) -> void:
	health_current -= amount
	
	if health_current <= 0:
		health_zero.emit()


func heal(amount:float) -> void:
	health_current = min(health_current + amount, health_max)
