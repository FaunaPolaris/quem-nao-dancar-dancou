extends Node2D

@onready var type : String
var	point_value : int = 100
signal pop_up

func	_ready():
	$Panel/key.set_text(type)

func	_input(event: InputEvent) -> void:
	if event.is_action(type):
		PlayerInfo.score += point_value
		pop_up.emit(point_value)
		queue_free()

func _on_lifespan_timeout() -> void:
	pop_up.emit(0)
	queue_free()


func _on_decay_timeout() -> void:
	point_value -= 10
