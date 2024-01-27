class_name Sniffable
extends Node

# Everything snatchable is sniffable
signal snatched
signal sniffed


func snatch() -> void:
	snatched.emit()


func sniff() -> void:
	sniffed.emit()
