class_name ScrollText
extends Node3D


signal half_done


var text:String : set = _set_text


@onready var label_3d = %Label3D
@onready var animation_player = $AnimationPlayer


func _ready():
	_set_text(text)
	animation_player.play("show")


func emit_half_done() -> void:
	half_done.emit()


func _on_animation_player_animation_finished(_anim_name):
	queue_free()


func _set_text(value:String) -> void:
	text = value
	if is_instance_valid(label_3d):
		label_3d.text = value
