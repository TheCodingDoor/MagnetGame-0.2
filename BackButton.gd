extends TextureButton

func _on_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://Scenes/Misc/title_screen.tscn")


func _on_mouse_entered():
	$Hover.play()
