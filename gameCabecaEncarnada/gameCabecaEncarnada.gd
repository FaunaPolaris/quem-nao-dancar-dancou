extends Node2D

var save_score_screen = load("res://saveScore/saveScore.tscn")

func _on_button_pressed() -> void:
	PlayerInfo.score = int($TextEdit.text)
	get_tree().change_scene_to_packed(save_score_screen)
