class_name Snatchable
extends Node

# Everything snatchable is sniffable
signal snatched


func snatch() -> void:
	snatched.emit()


static func find(parent: Node) -> Snatchable:
	for child in parent.get_children():
		if child is Snatchable:
			return child

	return null
