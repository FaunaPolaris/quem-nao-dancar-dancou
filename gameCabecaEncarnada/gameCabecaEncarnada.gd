extends Node2D

@onready var bird = $CabecaEncarnada
@onready var birdFem = $TangaraFem
@onready var music = $AudioStreamPlayer
@onready var pioFx = $AudioStreamPlayer2
@onready var errorFx = $AudioStreamPlayer3

@export var left_bound: float = 530.0
@export var right_bound: float = 1048.0
@export var base_speed: float = 60.0
@export var hit_window: float = 0.4  

var current_speed: float = 0.0
var note_times: Array = []
var current_note_index: int = 0
var can_hit: bool = false
var is_moving_right: bool = true
var current_anim: String = "slide_right"
var active_note: Node2D = null
var note_scene := preload("res://gameCabecaEncarnada/note2/note2.tscn")
var popup_scene := preload("res://gameDancarino/popUp/popUp.tscn")

func _ready():
	load_note_data("res://gameCabecaEncarnada/assets/cabecaEncarnadaNotes.json")
	reset_game_state()
	
	music.play()
	start_movement()

func reset_game_state():
	PlayerInfo.score = 0
	PlayerInfo.streak = 0
	bird.position.x = 850
	bird.position.y = 625
	current_speed = base_speed
	current_anim = "slide_right"
	bird.play(current_anim)
	is_moving_right = true
	current_note_index = 0
	can_hit = false

func load_note_data(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	note_times = JSON.parse_string(file.get_as_text()).get("notes", [])
	file.close()

func start_movement():
	bird.play("success")
	await bird.animation_finished
	current_speed = base_speed * (1 if is_moving_right else -1)
	current_anim = "slide_right" if is_moving_right else "slide_left"
	bird.play(current_anim)

func _process(delta):
	$points.set_text("".join(PackedStringArray(["pontos: ", PlayerInfo.score])))
	if not music.playing:
		return
	
	bird.position.x += current_speed * delta
	
	bird.position.x = clamp(bird.position.x, left_bound, right_bound)
	
	if current_note_index < note_times.size():
		var current_time = music.get_playback_position()
		var note_time = note_times[current_note_index]
		
		if current_time >= note_time and not can_hit:
			start_hit_window()
		elif can_hit and current_time > note_time + hit_window:
			end_hit_window(false)

func start_hit_window():
	can_hit = true
	is_moving_right = !is_moving_right
	start_movement()

	active_note = note_scene.instantiate()
	active_note.type = " "  
	active_note.position = Vector2(1720, 880)
	add_child(active_note)

func end_hit_window(hit_registered: bool):
	if not hit_registered:
		handle_miss()
	can_hit = false
	current_note_index += 1

func _input(event):
	if event.is_action_pressed("dance"):
		if can_hit:
			can_hit = false
			register_hit()
		else:
			handle_miss_input()

func register_hit():
	var current_time = music.get_playback_position()
	var note_time = note_times[current_note_index]
	var time_diff = abs(current_time - note_time)
	 
	var accuracy = (1.0 - min(time_diff / hit_window, 1.0)) * 100  
	accuracy = clamp(accuracy - fmod(accuracy, 10), 0, 100) 
	
	if accuracy > 0:
		if active_note:
			active_note.pop(int(accuracy))
			active_note = null
		handle_hit_success(accuracy)
	else:
		handle_miss()

	end_hit_window(true)

func handle_hit_success(accuracy: int):
	PlayerInfo.score += accuracy
	PlayerInfo.streak += 1
	if PlayerInfo.streak > PlayerInfo.bestStreak:
		PlayerInfo.bestStreak = PlayerInfo.streak

	var popup = popup_scene.instantiate()
	popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
	if accuracy > 75:
		popup.get_node("perfect").show()
		#if pioFx.is_playing() == false:
		pioFx.play()
		birdFem.play("love")
		await bird.animation_finished
	elif accuracy > 55:
		popup.get_node("good").show()
	elif accuracy > 10:
		popup.get_node("okay").show()
	else:
		popup.get_node("missed").show()
	add_child(popup)

func handle_miss():
	PlayerInfo.streak = 0
	var popup = popup_scene.instantiate()
	popup.position = Vector2(randi_range(200, 1720), randi_range(200, 880))
	popup.get_node("missed").show()
	birdFem.play("hate")
	await bird.animation_finished
	birdFem.play("idle")
	add_child(popup)
	
func handle_miss_input():
	PlayerInfo.streak = 0


func _on_audio_stream_player_finished() -> void:
	var scoreSave = load("res://saveScore/saveScore.tscn")
	get_tree().change_scene_to_packed(scoreSave)
