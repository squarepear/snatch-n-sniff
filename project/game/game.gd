extends Node3D

@onready var pause_menu := $PauseMenu

func _ready():
	pause_menu.visible=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()


func _toggle_pause():
	var paused:= not get_tree().paused
	get_tree().paused = paused
	pause_menu.visible = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED


func _on_resume_button_pressed():
	_toggle_pause()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
