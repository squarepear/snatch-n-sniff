class_name SnatchedAlarm
extends Sprite3D


signal activated
signal deactivated

const ROTATION_SPEED := 8.0

var active := false


func _process(delta):
	if not active:
		return

	rotate_y(delta * ROTATION_SPEED)


func activate() -> void:
	active = true
	billboard = BaseMaterial3D.BILLBOARD_DISABLED
	activated.emit()


func deactivate() -> void:
	active = false
	billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	deactivated.emit()
