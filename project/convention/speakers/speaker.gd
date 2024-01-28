extends Node3D


@export var activation_area: Area3D

@onready var audio_player: AudioStreamPlayer3D = %AudioStreamPlayer3D


func _ready():
	if not activation_area:
		return

	activation_area.body_entered.connect(play)
	activation_area.body_exited.connect(stop)


func play(_ignore = null) -> void:
	audio_player.play()


func stop(_ignore = null) -> void:
	audio_player.stop()
