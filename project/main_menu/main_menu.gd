extends Node2D


func _ready():
	$AnimationPlayer.play("title_sequence")


func _on_convention_button_pressed():
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_credits_pressed():
	%CreditsLabel.show()


func _on_ok_button_pressed():
	%CreditsLabel.hide()
