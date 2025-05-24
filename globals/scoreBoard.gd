extends Node

var	dancarino	: Array = []
var encarnado	: Array = []

func	addCurrentPlayer():
	if PlayerInfo.current_bird == "dancarino":
		dancarino.append([PlayerInfo.score, PlayerInfo.player_name])
		dancarino.sort()
		dancarino.reverse()
		if dancarino.size() > 9:
			dancarino.pop_back()
	if PlayerInfo.current_bird == "encarnado":
		encarnado.append([PlayerInfo.score, PlayerInfo.player_name])
		encarnado.sort()
		encarnado.reverse()
		if encarnado.size() > 9:
			encarnado.pop_back()

func	loadTo(label, bird_type):
	var complete_score : String = ""
	if bird_type == "encarnado":
		for value in encarnado:
			complete_score = "".join(PackedStringArray([complete_score, value[1], " : ", value[0], "\n"]))
	if bird_type == "dancarino":
		for value in dancarino:
			complete_score = "".join(PackedStringArray([complete_score, value[1], " : ", value[0], "\n"]))
	label.set_text(complete_score)
