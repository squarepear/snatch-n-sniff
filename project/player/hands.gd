class_name Hands
extends TextureRect


var held_item: SniffdexEntry
var is_sniffing := false
var has_sniffed := false

@onready var hand_texture := texture
@onready var sniff_timer := %SniffTimer


func _ready() -> void:
	sniff_timer.timeout.connect(sniff_complete)


func snatch(snatchable: Snatchable) -> void:
	if held_item:
		return

	held_item = snatchable.sniffdex_entry
	texture = held_item.hand_sprite

	snatchable.snatch()


func start_sniffing() -> void:
	if is_sniffing or not held_item:
		return

	sniff_timer.start(held_item.sniff_time)
	is_sniffing = true


func sniff_complete() -> void:
	if not is_sniffing:
		return

	print("SNIFF MODE ENGAGED")

	has_sniffed = true


func stop_sniffing() -> void:
	is_sniffing = false

	if not has_sniffed:
		return

	sniff(held_item)


func sniff(sniffdex_entry: SniffdexEntry) -> void:
	if not sniffdex_entry:
		return

	texture = hand_texture
	held_item = null


func _input(event: InputEvent):
	if event.is_action_pressed("sniff"):
		start_sniffing()
	if event.is_action_released("sniff"):
		stop_sniffing()
