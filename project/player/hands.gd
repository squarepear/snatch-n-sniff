class_name Hands
extends Node3D

signal snatched_snatchable(snatchable: Snatchable)
signal item_dropped

var held_item: SniffdexEntry

@onready var texture_rect := $HandTexture
@onready var hand_texture :Texture2D= texture_rect.texture
@onready var start_position :int= texture_rect.position.x
@onready var snatch_detector := $SnatchDetector
@onready var snatched_alarm: AudioStreamPlayer = $SnatchedAlarm


func snatch() -> void:
	if held_item:
		return
	if not snatch_detector.is_colliding():
		return
	var body: Node = snatch_detector.get_collider(0)
	var snatchable := Snatchable.find(body)
	if body is Person:
		Sfx.set_stream(body.snatch_attempt_audio)
		Sfx.play()
	if not snatchable:
		return
	held_item = snatchable.sniffdex_entry
	texture_rect.texture = held_item.hand_sprite
	snatched_alarm.play()
	snatched_snatchable.emit(snatchable)
	snatchable.snatch()


func drop() -> void:
	texture_rect.texture = hand_texture
	held_item = null
	Sfx.stop()



func shake(amount: float, delta: float) -> void:
	texture_rect.position.x += (randf() * 2.0 - 1.0) * amount * delta * 60.0


func reset_position() -> void:
	texture_rect.position.x = start_position


static func find(parent: Node) -> Hands:
	for child in parent.get_children():
		if child is Hands:
			return child

	return null

