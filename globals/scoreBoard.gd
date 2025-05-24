extends Node

var	dancarino	: Dictionary = {}
var encarnado	: Dictionary = {}

func	addCurrentPlayer():
	if PlayerInfo.current_bird == "dancarino":
		dancarino.merge({PlayerInfo.player_name : PlayerInfo.score})
	if PlayerInfo.current_bird == "encarnado":
		encarnado.merge({PlayerInfo.player_name : PlayerInfo.score})

func	loadTo(label):
	var complete_score : String = ""
	for key in encarnado:
		print("Found Player: ", key)
		complete_score = "".join(PackedStringArray([complete_score, key, " : ", encarnado.get(key), "\n"]))
		print(complete_score)
	label.set_text(complete_score)
