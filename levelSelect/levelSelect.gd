extends Node2D

var	mock_gameplay = load("res://gameCabecaEncarnada/gameCabecaEncarnada.tscn")
var	dancarino_gameplay = load("res://gameDancarino/gameDancarino.tscn")

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()

func	_ready():
	ScoreBoard.loadTo($"ParallaxBackground/ParallaxLayer5/TangaraCabeca-encarnada/ScoreBoard/VBox/Scores", "encarnado")
	ScoreBoard.loadTo($"ParallaxBackground/ParallaxLayer5/TangaraDancarino/ScoreBoard/VBox/Scores", "dancarino")
	PlayerInfo.score = 0

func _on_cabeca_encarnada_mouse_entered() -> void:
	$select1.play()
	$Camera2D.move_local_x(-200)
	$"ParallaxBackground/ParallaxLayer5/TangaraCabeca-encarnada/ScoreBoard/AnimationPlayer".play("popup")
	$"ParallaxBackground/ParallaxLayer5/TangaraCabeca-encarnada/spotlight".show()
	
func _on_cabeca_encarnada_mouse_exited() -> void:
	$Camera2D.move_local_x(200)
	$"ParallaxBackground/ParallaxLayer5/TangaraCabeca-encarnada/ScoreBoard/AnimationPlayer".play("popoff")
	$"ParallaxBackground/ParallaxLayer5/TangaraCabeca-encarnada/spotlight".hide()

func _on_dancarino_mouse_entered() -> void:
	$select2.play()
	$Camera2D.move_local_x(200)
	$ParallaxBackground/ParallaxLayer5/TangaraDancarino/ScoreBoard/AnimationPlayer.play("popup")
	$ParallaxBackground/ParallaxLayer5/TangaraDancarino/spotlight.show()
	
func _on_dancarino_mouse_exited() -> void:
	$Camera2D.move_local_x(-200)
	$ParallaxBackground/ParallaxLayer5/TangaraDancarino/ScoreBoard/AnimationPlayer.play("popoff")
	$ParallaxBackground/ParallaxLayer5/TangaraDancarino/spotlight.hide()


func _on_cabeca_encarnada_pressed() -> void:
	PlayerInfo.current_bird = "encarnado"
	get_tree().change_scene_to_packed(mock_gameplay)

func _on_dancarino_pressed() -> void:
	PlayerInfo.current_bird = "dancarino"
	get_tree().change_scene_to_packed(dancarino_gameplay)


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.
