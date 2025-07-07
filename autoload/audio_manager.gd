extends Node


signal play_audio(stream:AudioStream)


const PITCH_MARGIN:float = 0.3


func _ready() -> void:
	play_audio.connect(_on_play_audio)


func _on_play_audio(stream:AudioStream) -> void:
	var audio_player: = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = stream
	audio_player.pitch_scale = 1 + randf_range(-PITCH_MARGIN, PITCH_MARGIN)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)
