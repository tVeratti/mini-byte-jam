extends Control


@onready var label:Label = %Label
@onready var animation_player:AnimationPlayer = $AnimationPlayer


func render(result:Battle.Results) -> void:
	match(result):
		Battle.Results.SUCCESS:
			label.text = "Success!"
		Battle.Results.RETRY:
			label.text = "Retry!"
		Battle.Results.FAIL:
			label.text = "Fail"
	
	animation_player.play("show")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		animation_player.play("hide")
	else:
		queue_free()
