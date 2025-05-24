extends Node2D



func _on_cabeca_encarnada_mouse_entered() -> void:
	$Camera2D.move_local_x(-200)
	$"TangaraCabeca-encarnada/VBoxContainer".show()
	
func _on_cabeca_encarnada_mouse_exited() -> void:
	$Camera2D.move_local_x(200)
	$"TangaraCabeca-encarnada/VBoxContainer".hide()

func _on_dancarino_mouse_entered() -> void:
	$Camera2D.move_local_x(200)
	$TangaraDancarino/VBoxContainer.show()
	
func _on_dancarino_mouse_exited() -> void:
	$Camera2D.move_local_x(-200)
	$TangaraDancarino/VBoxContainer.hide()
