class_name Snatchable
extends Node

# Everything snatchable is sniffable
signal snatched

@export var sniffdex_entry: SniffdexEntry
@export var sprite3d: Sprite3D


func _ready():
	assert(sniffdex_entry, "THIS SNATCHABLE ITEM IS NOT SNIFFABLE! THAT VIOLATES RULE #1")
	sprite3d.texture = sniffdex_entry.sprite

func snatch() -> void:
	snatched.emit()
	
	get_parent().queue_free()


static func find(parent: Node) -> Snatchable:
	for child in parent.get_children():
		if child is Snatchable:
			return child

	return null
