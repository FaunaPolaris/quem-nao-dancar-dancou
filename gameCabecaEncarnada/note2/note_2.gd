extends Node2D

@export var type: String
signal popped

func _ready():
	$Panel/key.set_text(type)

func pop(accuracy: int):
	popped.emit(accuracy)
	queue_free()
