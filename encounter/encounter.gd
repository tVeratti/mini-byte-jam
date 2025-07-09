class_name Encounter
extends Node


signal ended


enum Types { BATTLE, JIG }
enum Results { SUCCESS, RETRY, FAIL }


@export var intro_audio:AudioStream = preload("uid://4wusemaxhk6d")
