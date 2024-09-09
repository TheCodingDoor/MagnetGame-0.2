extends CanvasLayer


func _ready():
	var fade_in = get_tree().create_tween()
	fade_in.tween_property($Holder,"modulate",Color(1,1,1,1),0.75)

func _on_large_button_next_level():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property($Holder,"modulate",Color(1,1,1,0),0.75)
	await fade_out.finished

	queue_free()
