extends Node2D

var level_select = preload("res://levelSelect/levelSelect.tscn")
var	leaving	: bool = false

func _process(_delta):
	if Input.is_anything_pressed() and !leaving:
		leaving = true
		$transition.play("transition")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(level_select)
