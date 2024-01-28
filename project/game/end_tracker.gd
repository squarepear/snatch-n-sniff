extends Node2D

@export var sniff_goal := 15
@export var failure_goal := 3

var num_sniffed := 0
var num_items_dropped := 0

func _ready() -> void:
	_update_sniff_label()
	_update_smacked_label()


func _update_sniff_label() -> void:
	%ObjectsSniffed.text = "Objects Sniffed: %d/%d" % [num_sniffed, sniff_goal]

func _update_smacked_label() -> void:
	%TimesSmacked.text = "Times Caught: %d/%d" % [num_items_dropped, failure_goal]


func _check_for_win() -> void:
	if num_sniffed >= sniff_goal:
		get_tree().call_deferred("change_scene_to_file", "res://main_menu/victory_screen.tscn")


func _check_for_lose() -> void:
	if num_items_dropped >= failure_goal:
		get_tree().call_deferred("change_scene_to_file", "res://main_menu/fail_screen.tscn")


func _on_player_sniffed() -> void:
	num_sniffed+=1
	_update_sniff_label()
	_check_for_win()


func _on_player_item_dropped():
	num_items_dropped +=1
	_update_smacked_label()
	_check_for_lose()
