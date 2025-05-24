extends RigidBody2D

func _on_lifespan_timeout() -> void:
	queue_free()
