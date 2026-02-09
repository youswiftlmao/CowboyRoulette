extends TextureButton


# Called when the node enters the scene tree for the first time.



func _on_pressed() -> void:
	get_tree().reload_current_scene()
