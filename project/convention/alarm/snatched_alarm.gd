class_name SnatchedAlarm
extends AnimatedSprite3D


signal activated(target: Node3D)
signal deactivated

const ROTATION_SPEED := 8.0

@export var target: Node3D

var active := false

@onready var off_animation := preload("res://convention/alarm/alarm_off_animation.tres")
@onready var on_animation := preload("res://convention/alarm/alarm_on_animation.tres")


func _process(delta):
	if not active:
		return

	rotate_y(delta * ROTATION_SPEED)


func activate() -> void:
	active = true
	billboard = BaseMaterial3D.BILLBOARD_DISABLED
	activated.emit(target)
	sprite_frames = on_animation
	play()
	get_tree().call_group("lights", "turn_red")


func deactivate() -> void:
	active = false
	billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	deactivated.emit()
	sprite_frames = off_animation
	stop()
	get_tree().call_group("lights", "return_to_normal")
	
