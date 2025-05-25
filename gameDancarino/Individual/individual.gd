extends Node2D

@export var	queue_position	: int
@export var is_player		: bool = false

var	positions	: Array = [Vector2(1266, 398), Vector2(1032, 535), Vector2(825, 588), Vector2(568, 609), Vector2(386, 526)]
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
		tween.tween_property(self, "global_position", self.global_position + Vector2(100, -200), .2)
		tween.tween_property(self, "global_position", self.global_position + Vector2(600, -200), .4)
		tween.tween_property(self, "global_position", positions[0], .2)
		queue_position = 1
		if is_player:
			emit_signal("player_flying")
	else:
		tween.tween_property(self, "global_position", self.global_position + Vector2(0, -50), .2)
		tween.tween_property(self, "global_position", positions[queue_position], .6)
		queue_position += 1
		if is_player:
			emit_signal("player_jumping")
