extends TextureButton

@export var next_scene:PackedScene
@export var label:String

func _ready():
	$Label.text = label

func _on_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_packed(next_scene)


func _on_mouse_entered():
	if(!disabled):
		$Hover.play()
