extends Node2D

@export var sniff_goal := 2

var num_sniffed := 0

func _ready() -> void:
	_update_sniff_label()


func _update_sniff_label() -> void:
	%ObjectsSniffed.text = "Objects Sniffed: %d/%d" % [num_sniffed, sniff_goal]


func _check_for_win() -> void:
	if num_sniffed >= sniff_goal:
		get_tree().change_scene_to_file("res://main_menu/victory_screen.tscn")


func _on_player_sniffed() -> void:
	num_sniffed+=1
	_update_sniff_label()
	_check_for_win()
