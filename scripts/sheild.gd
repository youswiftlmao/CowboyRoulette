extends TextureButton

var exited := false

func _on_mouse_entered() -> void:
	exited = false
	$AnimationPlayer.play("UPPIE")
	await $AnimationPlayer.animation_finished

	if exited:
		$AnimationPlayer.play("down ")

func _on_mouse_exited() -> void:
	exited = true
