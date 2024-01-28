extends Node2D

var _right_position := Vector2(575, 875)
var _left_position := Vector2(550,875)
@onready var _imp_hand : Sprite2D = $ImpHand


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_tween_left()


func _tween_right() -> void:
	var tween = create_tween()
	tween.tween_property(_imp_hand, "global_position", _right_position, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_left)


func _tween_left() -> void:
	var tween = create_tween()
	tween.tween_property(_imp_hand, "global_position", _left_position, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_right)


func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
