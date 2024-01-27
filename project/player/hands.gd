class_name Hands
extends TextureRect


signal started_sniffing
signal fully_sniffed
signal stopped_sniffing
signal completed_sniffing

var held_item: SniffdexEntry
var is_sniffing := false
var has_sniffed := false

@onready var hand_texture := texture
@onready var start_position := position.x
@onready var sniff_timer := %SniffTimer


func _ready() -> void:
	sniff_timer.timeout.connect(sniff_complete)


func _process(delta):
	if has_sniffed:
		_shake(8.0, delta)
	elif is_sniffing:
		_shake(1.0, delta)


func snatch(snatchable: Snatchable) -> void:
	if held_item:
		return

	held_item = snatchable.sniffdex_entry
	texture = held_item.hand_sprite

	snatchable.snatch()


func start_sniffing() -> void:
	if is_sniffing or not held_item:
		return

	started_sniffing.emit()
	sniff_timer.start(held_item.sniff_time)
	is_sniffing = true


func sniff_complete() -> void:
	if not is_sniffing:
		return

	has_sniffed = true
	fully_sniffed.emit()


func stop_sniffing() -> void:
	if not is_sniffing:
		return

	is_sniffing = false
	stopped_sniffing.emit()
	_reset_position()

	if not has_sniffed:
		sniff_timer.stop()
		return

	sniff(held_item)
	completed_sniffing.emit()
	has_sniffed = false


func sniff(sniffdex_entry: SniffdexEntry) -> void:
	if not sniffdex_entry:
		return

	drop()


func drop() -> void:
	texture = hand_texture
	held_item = null
	
	completed_sniffing.emit()


func _shake(amount: float, delta: float) -> void:
	position.x += (randf() * 2.0 - 1.0) * amount * delta * 60.0


func _reset_position() -> void:
	position.x = start_position


func _input(event: InputEvent):
	if event.is_action_pressed("sniff"):
		start_sniffing()
	if event.is_action_released("sniff"):
		stop_sniffing()


static func find(parent: Node) -> Hands:
	for child in parent.get_children():
		if child is Hands:
			return child

	return null

