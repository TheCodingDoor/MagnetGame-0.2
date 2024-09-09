extends CanvasLayer

func _ready():
	for i in 10:
		$GridContainer.get_child(i).disabled = !Globals.accessible_levels[i]
		$GridContainer.get_child(i).get_child(0).visible = Globals.accessible_levels[i]
