extends Node

var streak 			: int = 0
var _score: int = 0

var score:
	get: return _score
	set(value):
		print(">> SCORE SET TO", value, "FROM", _score, "BY:", get_stack())
		_score = value
var	player_name		: String = "None"
var	current_bird	: String = "Dancarino"
