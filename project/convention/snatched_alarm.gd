class_name SnatchedAlarm
extends Sprite3D


signal activated(target: Node3D)
signal deactivated

const ROTATION_SPEED := 8.0

var active := false

@export var target: Node3D


func _process(delta):
	if not active:
		return

	rotate_y(delta * ROTATION_SPEED)


func activate() -> void:
	active = true
	billboard = BaseMaterial3D.BILLBOARD_DISABLED
	activated.emit(target)


func deactivate() -> void:
	active = false
	billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	deactivated.emit()
