extends Sprite2D

func _ready():
	disappear()

func set_property(pos, tex):
	position = pos
	texture = tex

func disappear():
	var fade = get_tree().create_tween()
	fade.tween_property(self, "self_modulate", Color(1,1,1,0), 1)
	await fade.finished
	queue_free()
