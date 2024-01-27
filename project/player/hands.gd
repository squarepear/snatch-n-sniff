class_name Hands
extends TextureRect


var held_item: SniffdexEntry

@onready var hand_texture = texture

func snatch(snatchable: Snatchable) -> void:
	if held_item:
		return

	held_item = snatchable.sniffdex_entry
	texture = held_item.hand_sprite

	snatchable.snatch()


func sniff(sniffdex_entry: SniffdexEntry) -> void:
	if not sniffdex_entry:
		return

	texture = hand_texture
	held_item = null


func _input(event: InputEvent):
	if event.is_action_pressed("sniff"):
		sniff(held_item)
