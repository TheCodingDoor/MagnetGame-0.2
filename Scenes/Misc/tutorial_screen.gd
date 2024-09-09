extends Area2D

var is_displayed = false
@export var id: int = 0;
var title_text = ["Basic Movement","Magnet Movement","Non-Magnetable Tiles","Objects","Enemies"]
var text = ["[center] In order to move, use \"A\" and \"D\" to move left and right, and use \"W\" to jump (even though you needed to know that to get here...). [/center]","[center]To use the magnet, first move your mouse to the direction that you want to use it relative to the player (e.g. put it below the player to use it downwards). Then, press the LEFT mouse button to ATTRACT yourself to walls or other objects to you, or the RIGHT mouse button to REPEL yourself from walls or other objects from you.  [/center]","[center]Yellow tiles are NON-MAGNETABLE: you cannot attract to them or repel from them. Keep their location in mind, as they may hint ot what you need to do!  [/center]", "[center]You will encounter a variety of objects throughout the facility, that in turn fulfill a variety of purposes. Most objects can be interacted with through the magnet, so experiment to figure out how to use each one to progress! [/center]","[center] Your journey throughout this facility will not be without peril. There a a number of beings that will attempt to kill you, so tread with care and use your magnet to get past them."]


func _ready():
	$ScreenPopup.get_child(0).modulate = Color(1,1,1,0)
	$ScreenPopup.get_child(0).get_child(2).get_child(0).text = title_text[id]
	$ScreenPopup.get_child(0).get_child(2).get_child(1).text = text[id]



func _process(_delta):
	if(has_overlapping_bodies() && Input.is_action_just_pressed("interact")):
		$Interact.play()
		if(!is_displayed):
			var popup_fade_in = get_tree().create_tween()
			popup_fade_in.tween_property($ScreenPopup.get_child(0),"modulate",Color(1,1,1,1),0.25)
			$"../../Player".can_move = false
			is_displayed = true
		else:
			var popup_fade_out = get_tree().create_tween()
			popup_fade_out.tween_property($ScreenPopup.get_child(0),"modulate",Color(1,1,1,0),0.25)
			$"../../Player".can_move = true
			is_displayed = false


func _on_body_entered(_body):
	var fade_in = get_tree().create_tween()
	fade_in.tween_property($Prompt,"modulate",Color(1,1,1,1),0.5)


func _on_body_exited(body):
	var fade_out = get_tree().create_tween()
	fade_out.tween_property($Prompt,"modulate",Color(1,1,1,0),0.5)
