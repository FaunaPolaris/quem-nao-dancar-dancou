extends Node2D

func _on_line_edit_text_submitted(new_text: String) -> void:
	PlayerInfo.player_name = new_text
	ScoreBoard.addCurrentPlayer()
	get_tree().change_scene_to_file("res://levelSelect/levelSelect.tscn")
