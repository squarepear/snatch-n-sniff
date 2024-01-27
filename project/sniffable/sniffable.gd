class_name Sniffable
extends Node

# Everything snatchable is sniffable
signal snatched
signal sniffed


func snatch() -> void:
	snatched.emit()


func sniff() -> void:
	sniffed.emit()


static func find(parent: Node) -> Sniffable:
	for child in parent.get_children():
		if child is Sniffable:
			return child

	return null
