extends Node

var	dancarino	: Dictionary = {}
var encarnado	: Array = []

func	addCurrentPlayer():
	if PlayerInfo.current_bird == "dancarino":
		dancarino.merge({PlayerInfo.score : PlayerInfo.player_name})
	if PlayerInfo.current_bird == "encarnado":
		encarnado.append([PlayerInfo.score, PlayerInfo.player_name])
		encarnado.sort()
		encarnado.reverse()
		if encarnado.size() > 9:
			encarnado.pop_back()

func	loadTo(label):
	var complete_score : String = ""
	for value in encarnado:
		complete_score = "".join(PackedStringArray([complete_score, value[1], " : ", value[0], "\n"]))
	label.set_text(complete_score)
