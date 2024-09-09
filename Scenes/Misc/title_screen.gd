extends CanvasLayer

@onready var target_pos = []

func _ready():
	target_pos.resize(9)
	for i in range(9):
		target_pos[i] = Vector2(307 + 125*i + randf_range(0,30), 108 + randf_range(0,30))


func _process(delta):
	for i in range(9):
		if($TitleLetters.get_child(i).position != target_pos[i]):
			$TitleLetters.get_child(i).position = $TitleLetters.get_child(i).position.move_toward(target_pos[i],0.2)
		else:
			target_pos[i] = Vector2(307 + 125*i + randf_range(0,30), 108 + randf_range(0,30))
