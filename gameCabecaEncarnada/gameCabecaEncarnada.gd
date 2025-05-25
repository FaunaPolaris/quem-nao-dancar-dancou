extends Node2D

# Nodes
@onready var bird = $CabecaEncarnada
@onready var music = $AudioStreamPlayer

# Movement settings
@export var left_bound: float = 300.0
@export var right_bound: float = 1620.0
@export var base_speed: float = 150.0
@export var hit_window: float = 0.2  # 150ms window for perfect hits

# Game state
var current_speed: float = 0.0
var note_times: Array = []
var current_note_index: int = 0
var can_hit: bool = false
var is_moving_right: bool = true
var current_anim: String = "slide_right"

func _ready():
	# Initialize game
	load_note_data("res://gameCabecaEncarnada/assets/cabecaEncarnadaNotes.json")
	reset_game_state()
	
	# Start music and movement
	music.play()
	start_movement()

func reset_game_state():
	PlayerInfo.score = 0
	PlayerInfo.streak = 0
	bird.position.x = 700
	bird.position.y = 700
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
	current_speed = base_speed * (1 if is_moving_right else -1)
	current_anim = "slide_right" if is_moving_right else "slide_left"
	bird.play(current_anim)

func _process(delta):
	if not music.playing:
		return
	
	# Update bird position
	bird.position.x += current_speed * delta
	
	# Boundary checks
	bird.position.x = clamp(bird.position.x, left_bound, right_bound)
	
	# Note timing checks
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

func end_hit_window(hit_registered: bool):
	if not hit_registered:
		handle_miss()
	can_hit = false
	current_note_index += 1

func _input(event):
	if event.is_action_pressed("dance"):
		if can_hit:
			register_hit()
		else:
			handle_missed_input()

func register_hit():
	var current_time = music.get_playback_position()
	var note_time = note_times[current_note_index]
	var time_diff = abs(current_time - note_time)
	
	# Calculate accuracy (0-100 in 10-point steps)
	var accuracy = int(ceil((1.0 - (time_diff / hit_window)) * 100))
	accuracy = clamp(accuracy - (accuracy % 10), 0, 100)  # Round down to nearest 10
	
	if accuracy > 0:
		handle_hit_success(accuracy)
	else:
		handle_missed_hit()
	
	end_hit_window(true)

func handle_hit_success(accuracy: int):
	# Update score and streak
	PlayerInfo.score += accuracy
	PlayerInfo.streak += 1
	
	# Visual feedback
	bird.play("success")
	await bird.animation_finished
	bird.play(current_anim)

func handle_missed_hit():
	PlayerInfo.streak = 0
	#bird.play("miss")
	#await bird.animation_finished
	#bird.play(current_anim)

func handle_miss():
	PlayerInfo.streak = 0
	#bird.play("miss")
	#await bird.animation_finished
	#bird.play(current_anim)

func handle_missed_input():
	PlayerInfo.streak = 0
	#bird.play("miss")
	#await bird.animation_finished
	#bird.play(current_anim)
