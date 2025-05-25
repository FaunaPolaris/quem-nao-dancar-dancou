extends Node2D

@onready var bird = $CabecaEncarnada
@onready var music = $AudioStreamPlayer
@onready var hit_ring = $ColorRect2
@onready var cue_circle = $Panel

@export var left_bound: float = 300.0
@export var right_bound: float = 1620.0
@export var base_speed: float = 150.0
@export var hit_window: float = 0.2

@export var cue_duration := 0.5  # Time it takes for the cue to reach the ring
@export var cue_start_y := 900.0
@export var cue_end_y := 400.0  # Should match hit_ring.y position

var current_speed: float = 0.0
var note_times: Array = []
var current_note_index: int = 0
var can_hit: bool = false
var is_moving_right: bool = true
var current_anim: String = "slide_right"

var cue_active := false
var cue_start_time := -1.0

func _ready():
	load_note_data("res://gameCabecaEncarnada/assets/cabecaEncarnadaNotes.json")
	reset_game_state()

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

	cue_circle.visible = false
	cue_circle.position.y = cue_start_y

func load_note_data(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	note_times = JSON.parse_string(file.get_as_text()).get("notes", [])
	file.close()

func start_movement():
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

		# Launch the cue before the note
		if not cue_active and current_time >= note_time - cue_duration:
			start_cue_animation(note_time)

		# Animate cue rising
		if cue_active:
			var t = (current_time - cue_start_time) / cue_duration
			t = clamp(t, 0, 1)
			cue_circle.position.y = lerp(cue_start_y, cue_end_y, t)

			if t >= 1.0:
				cue_active = false
				cue_start_time = -1.0

		if current_time >= note_time and not can_hit:
			start_hit_window()
		elif can_hit and current_time > note_time + hit_window:
			end_hit_window(false)

func start_cue_animation(target_time: float):
	cue_active = true
	cue_start_time = music.get_playback_position()
	cue_circle.position.y = cue_start_y
	cue_circle.visible = true

func start_hit_window():
	can_hit = true
	is_moving_right = !is_moving_right
	start_movement()

func end_hit_window(hit_registered: bool):
	if not hit_registered:
		handle_miss()
	can_hit = false
	current_note_index += 1
	cue_circle.visible = false

func _input(event):
	if event.is_action_pressed("dance"):
		if can_hit:
			can_hit = false
			register_hit()
		else:
			handle_missed_input()

func register_hit():
	var current_time = music.get_playback_position()
	var note_time = note_times[current_note_index]
	var time_diff = abs(current_time - note_time)

	if time_diff > hit_window:
		handle_missed_hit()
		end_hit_window(true)
		return

	var accuracy = int(round((1.0 - (time_diff / hit_window)) * 100.0))
	accuracy = clamp(accuracy - (accuracy % 10), 0, 100)

	if accuracy > 10:
		handle_hit_success(accuracy)
	else:
		handle_missed_hit()

	end_hit_window(true)

func handle_hit_success(accuracy: int):
	PlayerInfo.score += accuracy
	PlayerInfo.streak += 1
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
	cue_circle.visible = false
	#bird.play("miss")
	#await bird.animation_finished
	#bird.play(current_anim)

func handle_missed_input():
	PlayerInfo.streak = 0
	#bird.play("miss")
	#await bird.animation_finished
	#bird.play(current_anim)
