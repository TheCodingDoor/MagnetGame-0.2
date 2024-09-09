extends Area2D


func _ready():
	if(name == "EntranceElevator"):
		$Doors.z_index = 1


func _process(delta):
	if(has_overlapping_bodies() && Input.is_action_just_pressed("interact") && name == "ExitElevator"):
		var fade_out = get_tree().create_tween()
		fade_out.tween_property($Prompt,"modulate",Color(1,1,1,0),0.5)
		$"../Player".can_move = false
		
		Globals.accessible_levels[int(get_tree().get_current_scene().get_name().substr(5))] = true
		
		$Ding.play()
		
		var finished_popup = preload("res://Scenes/Misc/level_complete_popup.tscn").instantiate()
		add_child(finished_popup)
		
		await finished_popup.tree_exited
		
		$AnimationPlayer.play("open")


func _on_body_entered(body):
	if(name == "ExitElevator"):
		var fade_in = get_tree().create_tween()
		fade_in.tween_property($Prompt,"modulate",Color(1,1,1,1),0.5)


func _on_body_exited(body):
	var fade_out = get_tree().create_tween()
	fade_out.tween_property($Prompt,"modulate",Color(1,1,1,0),0.5)


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "open"):
		if(name == "ExitElevator"):
			$Doors.z_index = 1
		else:
			$Doors.z_index = 0
		$AnimationPlayer.play("close")
	elif(anim_name == "close"):
		if(name == "ExitElevator"):
			$"../Player".entered_elevator()
		else:
			$"../Player".can_move = true
			$"../Player".can_float = false


func _on_player_elevator_open():
	$Ding.play()
	$AnimationPlayer.play("open")
