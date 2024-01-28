@tool
extends HSlider
class_name AudioBusSlider

@export var bus_name := "Master"

var _audio_bus_index

@onready var _audio_player := $AudioStreamPlayer

func _ready():
	_audio_player.bus = bus_name
	_on_value_changed(0)
	_audio_bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(_audio_bus_index))

func _on_drag_ended(_value_changed):
	if value == 0:
		AudioServer.set_bus_mute(_audio_bus_index, true)
	else:
		AudioServer.set_bus_mute(_audio_bus_index, false)
		AudioServer.set_bus_volume_db(_audio_bus_index, linear_to_db(value))
		_audio_player.play()
	print((AudioServer.get_bus_volume_db(_audio_bus_index)))


func _on_value_changed(_value):
	$Label.text = bus_name + ": " + str(value*100)
