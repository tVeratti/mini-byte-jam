class_name PlayerState
extends Node


signal finished(next_state_path: String, data: Dictionary)


const IDLE: = "Idle"
const MOVE_INTENT: = "MoveIntent"
const MOVE: = "Move"
const BUFF: = "Buff"
const HEAL: = "Heal"
const ENCOUNTER: = "Encounter"


@onready var player:Player = owner


func enter(_previous_state_path: String, _data := {}) -> void: pass
func update(_delta: float) -> void: pass
func exit() -> void: pass
