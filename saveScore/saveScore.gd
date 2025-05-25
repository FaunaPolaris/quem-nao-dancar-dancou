extends Node2D

var highscore : int = 0

func	_ready():
	$Score.set_text("".join(PackedStringArray([$Score.text, str(PlayerInfo.score)])))
	if PlayerInfo.current_bird == "dancarino" and ScoreBoard.dancarino.size():
		highscore = ScoreBoard.dancarino[0][0]
	if PlayerInfo.current_bird == "encarnado" and ScoreBoard.encarnado.size():
		highscore = ScoreBoard.encarnado[0][0]
	$selected_bird.play(PlayerInfo.current_bird)
	$highscore.set_text("".join(PackedStringArray([$highscore.text, str(highscore)])))
	if PlayerInfo.score > highscore:
		$"new best".play()
	else:
		$normal.play()

func _on_line_edit_text_submitted(new_text: String) -> void:
	PlayerInfo.player_name = new_text
	ScoreBoard.addCurrentPlayer()
	get_tree().change_scene_to_file("res://levelSelect/levelSelect.tscn")
