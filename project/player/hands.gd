class_name Hands
extends Node3D

signal snatched_snatchable(snatchable: Snatchable)

var held_item: SniffdexEntry

@onready var texture_rect := $HandTexture
@onready var hand_texture :Texture2D= texture_rect.texture
@onready var start_position :int= texture_rect.position.x
@onready var snatch_detector := $SnatchDetector
@onready var snatch_attempt_player : AudioStreamPlayer = %PersonSnatchAttemptPlayer


func snatch() -> void:
	if held_item:
		return
	if not snatch_detector.is_colliding():
		return
	var body: Node = snatch_detector.get_collider(0)
	var snatchable := Snatchable.find(body)
	if body is Person:
		snatch_attempt_player.stream = body.get_snatch_attempt_audio()
		snatch_attempt_player.play()
	if not snatchable:
		return
	held_item = snatchable.sniffdex_entry
	texture_rect.texture = held_item.hand_sprite
	snatched_snatchable.emit(snatchable)
	snatchable.snatch()


func drop() -> void:
	texture_rect.texture = hand_texture
	held_item = null


func shake(amount: float, delta: float) -> void:
	texture_rect.position.x += (randf() * 2.0 - 1.0) * amount * delta * 60.0


func reset_position() -> void:
	texture_rect.position.x = start_position


static func find(parent: Node) -> Hands:
	for child in parent.get_children():
		if child is Hands:
			return child

	return null

