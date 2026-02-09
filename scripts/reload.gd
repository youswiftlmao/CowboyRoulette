extends TextureButton

var exited := false

func _on_mouse_entered() -> void:
	exited = false
	$AnimationPlayer.play("UP")
	await $AnimationPlayer.animation_finished

	if exited:
		$AnimationPlayer.play("don")

func _on_mouse_exited() -> void:
	exited = true
