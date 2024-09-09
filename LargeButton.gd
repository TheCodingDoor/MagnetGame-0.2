extends TextureButton

@export var label:String
@export var next_scene:String
@export var type:int

signal nextLevel


func _ready():
	$Label.text = label


func _on_pressed():
	$Click.play()
	await $Click.finished
	
	if(type == 1):
		if(get_tree().paused):
			get_tree().paused = false
		get_tree().change_scene_to_file(next_scene)
	elif(type == 2):
		get_tree().quit(0)
	else:
		nextLevel.emit()


func _on_mouse_entered():
	$Hover.play()
