extends Node2D

var save_score_screen = load("res://saveScore/saveScore.tscn")
var	note_queue	: Array = []
var is_waiting	: bool = false
var	note_type	: String

func	_process(_delta):
	$points.set_text("".join(PackedStringArray(["pontos: ", PlayerInfo.score, "0000"])))
	if note_queue.size() > 0 and !is_waiting:
		is_waiting = true
		spawnNote(note_queue[0][0], note_queue[0][1])

func	spawnNote(_note_type : String, delay : float):
	note_type = _note_type
	$pointSpawn.set_wait_time(delay)
	$pointSpawn.start()

func _on_point_spawn_timeout() -> void:
	is_waiting = false   
	var note_scene = load("res://gameDancarino/note/note.tscn")
	var new_note = note_scene.instantiate()
	new_note.type = note_type
	new_note.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
	new_note.pop_up.connect(_pop_it)
	note_queue.pop_front()
	add_child(new_note)

func	_pop_it(accuracy : int):
	if accuracy == 100:
		var popup_scene = load("res://gameDancarino/popUp/popUp.tscn")
		var new_popup = popup_scene.instantiate()
		new_popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
		new_popup.get_node("perfect").show()
		add_child(new_popup)
	elif accuracy > 80:
		var popup_scene = load("res://gameDancarino/popUp/popUp.tscn")
		var new_popup = popup_scene.instantiate()
		new_popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
		new_popup.get_node("good").show()
		add_child(new_popup)
	elif accuracy > 60:
		var popup_scene = load("res://gameDancarino/popUp/popUp.tscn")
		var new_popup = popup_scene.instantiate()
		new_popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
		new_popup.get_node("okay").show()
		add_child(new_popup)
	else:
		var popup_scene = load("res://gameDancarino/popUp/popUp.tscn")
		var new_popup = popup_scene.instantiate()
		new_popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
		new_popup.get_node("missed").show()
		add_child(new_popup)

func _on_individual_5_player_flying() -> void:
	note_queue.append(["W", .2])
	note_queue.append(["D", .2])
	note_queue.append(["S", .4])

func _on_individual_5_player_jumping() -> void:
	note_queue.append(["A", .2])
	
func _on_timeout_timeout() -> void:
	get_tree().change_scene_to_packed(save_score_screen)
