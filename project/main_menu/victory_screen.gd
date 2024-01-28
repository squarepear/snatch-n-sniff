extends Node2D


var _right_position := Vector2(1763, 877)
var _left_position := Vector2(134,877)

@onready var _hands : Sprite2D = $Hands


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_tween_right()

func _tween_left() -> void:
	var _tween = create_tween()
	_tween.tween_property(_hands, "global_position", _left_position, 1).set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_callback(_tween_right)


func _tween_right() -> void:
	var _tween = create_tween()
	_tween.tween_property(_hands, "global_position", _right_position, 1).set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_callback(_tween_left)


func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	# If quitting doesn't work, go to main menu
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
