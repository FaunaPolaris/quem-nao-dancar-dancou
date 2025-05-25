extends Node2D

var level_select = preload("res://levelSelect/levelSelect.tscn")
var	leaving	: bool = false
var	label_is_shown : bool = true
var counter : int = 0

func _process(_delta):
	if Input.is_anything_pressed() and !leaving:
		leaving = true
		$transition.play("transition")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(level_select)


func _on_blink_timeout() -> void:
	if label_is_shown and counter > 3:
		$Label.hide()
		counter = 0
	else:
		counter += 1
		$Label.show()
