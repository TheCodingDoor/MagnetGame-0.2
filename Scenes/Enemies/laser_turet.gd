extends StaticBody2D

var shooting = false


func _process(delta):
	if(abs(position.x-Globals.player_pos.x)<2000 && abs(position.x-Globals.player_pos.x)<2000):
		#thanks godot docs
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create($Head.global_position, Globals.player_pos)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		
		if(result && result.collider is CharacterBody2D):
			if(!$ChargeUp.playing):
				$ChargeUp.play()
			if(!shooting):
				$Head.global_rotation = ($Head.global_position-Globals.player_pos).normalized().angle()
				$Head/Line2D.set_point_position(1, Vector2(-$Head/RayCast2D.get_collision_point().distance_to($Head.global_position),-35))
			if($FireTimer.time_left == 0 && !shooting):
				$FireTimer.start()
		else:
			$FireTimer.stop()
			$ChargeUp.stop()


func _on_timer_timeout():
	$LaserBlast.play()
	var laser_expand = get_tree().create_tween()
	laser_expand.tween_property($Head/Line2D,"width",14,0.25)
	$Head/Area2D.monitoring = true
	$LaserTimer.start()
	shooting = true


func _on_laser_timer_timeout():
	$Head/Area2D.monitoring = false
	var laser_contract = get_tree().create_tween()
	laser_contract.tween_property($Head/Line2D,"width",2,0.25)
	shooting = false


func _on_area_2d_body_entered(body):
	$"../Player".dead()
