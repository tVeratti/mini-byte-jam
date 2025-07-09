extends Control


func _on_volume_value_changed(value):
	_set_volume(value)


func _set_volume(volume:float) -> void:
	var volume_db:float = lerp(-50.0, 5.0, clamp(volume, 0.0, 1.0))
	AudioServer.set_bus_mute(0, volume < 0.1)
	AudioServer.set_bus_volume_db(0, volume_db)
