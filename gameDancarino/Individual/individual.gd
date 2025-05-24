extends Node2D

@export var	queue_position	: int
@export var is_player		: bool = false

signal player_flying
signal player_jumping

func _ready():
	if is_player:
		$ColorRect.show()

func _on_timer_timeout() -> void:
	moveOnQueue()
	
func	moveOnQueue():
	var	tween : Tween
	tween = get_tree().create_tween()
	if queue_position == 5:
		tween.tween_property(self, "global_position", self.global_position + Vector2(100, -200), .5)
		tween.tween_property(self, "global_position", self.global_position + Vector2(600, -200), 1)
		tween.tween_property(self, "global_position", self.global_position + Vector2(800, 0), .5)
		queue_position = 1
		if is_player:
			emit_signal("player_flying")
	else:
		tween.tween_property(self, "global_position", self.global_position - Vector2(200, 0), 1)
		queue_position += 1
		if is_player:
			emit_signal("player_jumping")
