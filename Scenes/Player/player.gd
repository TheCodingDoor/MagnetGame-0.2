extends CharacterBody2D

@export var startX:int = 85
@export var startY:int = -75

@export var next_scene:PackedScene

var magnet_power = 360
var current_raycast
var can_move = true
var magnet_dir
var can_float = false
var counter = 0

const SPEED = 200.0
const JUMP_VELOCITY = -370.0


var is_dead = false


var x_factor = 0
var y_factor = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.8

signal elevator_open

func _ready():
	$AnimationPlayer.play("RESET")
	position = Vector2(startX,startY)
	
	if(get_tree().get_current_scene().get_name() != "Level01"):
		$Skeleton2D.visible = false
		can_float = true
		can_move = false

		var move_up = get_tree().create_tween()
		move_up.tween_property($".","position",global_position + Vector2(0,-428),1)
		await move_up.finished

		$Skeleton2D.visible = true

		elevator_open.emit()
		$Skeleton2D/Torso/Head/Sprite2D.frame = 4
		set_checkpoint(position.x, position.y)
	else:
		can_move = false
		$"../UI".get_child(0).modulate = Color(1,1,1,0)
		
		$Camera.zoom = Vector2(5,5)
		$AnimationPlayer.play("wake_up")
		await $AnimationPlayer.animation_finished
		
		velocity = Vector2(150,JUMP_VELOCITY)
		$AudioPlayers/Jump.play()
		var zoom_out = get_tree().create_tween()
		zoom_out.tween_property($Camera, "zoom", Vector2(1.5,1.5),1)
		zoom_out.parallel().tween_property($"../UI".get_child(0), "modulate", Color(1,1,1,1),1)
		await zoom_out.finished
		
		can_move = true
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
	set_collision_mask_value(5, true)

func _physics_process(delta):
	if(!is_on_floor() && !can_float):
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("up") && is_on_floor() && can_move:
		$AudioPlayers/Jump.play()
		velocity.y += JUMP_VELOCITY
	
	var mouse_angle = round(rad_to_deg((global_position-get_global_mouse_position()).normalized().angle()))
	
	var direction = Input.get_axis("left", "right")
	
	if($Skeleton2D.scale.x != direction*0.25 && direction != 0 && can_move):
		$Skeleton2D.scale.x = direction*0.25
	
	
	if($AnimationPlayer.current_animation != "wake_up" && $AnimationPlayer.current_animation != "dead"):
		if(velocity.y < 0):
			$AudioPlayers/Walk.stop()
			$AnimationPlayer.play("jump_up")
			
		elif(velocity.y > 0):
			$AnimationPlayer.play("jump_down")
		elif(velocity.x != 0):
			counter = 0
			$AnimationPlayer.play("walk")
			if(!$AudioPlayers/Walk.playing):
				$AudioPlayers/Walk.play()
		else:
			$AnimationPlayer.play("idle")
			if(counter<10):
				counter+=1
			else:
				$AudioPlayers/Walk.stop()
	
	if($AnimationPlayer.current_animation == "dead"):
		$AudioPlayers/Walk.stop()
	
	var move_arms = get_tree().create_tween()
	move_arms.set_parallel()
	
	if(can_move):
		if(mouse_angle<-45 && mouse_angle>-135):
			#down
			move_arms.tween_property($Targets/LeftArmTarget,"position",Vector2(-32,56),0.3)
			move_arms.tween_property($Targets/RightArmTarget,"position",Vector2(36,48),0.3)
		elif(mouse_angle>45 && mouse_angle<135):
			#up
			move_arms.tween_property($Targets/LeftArmTarget,"position",Vector2(28,-68),0.3)
			move_arms.tween_property($Targets/RightArmTarget,"position",Vector2(56,-56),0.3)
		elif(mouse_angle<45 && mouse_angle>-45):
			#left
			move_arms.tween_property($Targets/LeftArmTarget,"position",Vector2(-100,32),0.3)
			move_arms.tween_property($Targets/RightArmTarget,"position",Vector2(-44,-44),0.3)
		else:
			#right
			move_arms.tween_property($Targets/LeftArmTarget,"position",Vector2(44,16),0.3)
			move_arms.tween_property($Targets/RightArmTarget,"position",Vector2(72,12),0.3)
	
	if(!((Input.is_action_pressed("magnet_repel") || Input.is_action_pressed("magnet_attract")) && ((mouse_angle<45 && mouse_angle>-45) || (mouse_angle > 135 || mouse_angle<-135))) && can_move):
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if(!(Input.is_action_pressed("magnet_repel") || Input.is_action_pressed("magnet_attract")) && magnet_power < 360):
		magnet_power += 2
	
	if(mouse_angle<-45 && mouse_angle>-135):
		current_raycast = $Raycasts/RayCastDown
	elif(mouse_angle>45 && mouse_angle<135):
		current_raycast = $Raycasts/RayCastUp
	elif(mouse_angle<45 && mouse_angle>-45):
		current_raycast = $Raycasts/RayCastLeft
	else:
		current_raycast = $Raycasts/RayCastRight
	
	if(current_raycast.is_colliding() && can_move):
		$Crosshair.visible = true
		$Crosshair.global_position = current_raycast.get_collision_point()
	else:
		$Crosshair.visible = false
	
	if((Input.is_action_pressed("magnet_repel") || Input.is_action_pressed("magnet_attract")) && magnet_power > 0 && can_move):
		magnet_power -= 1
		if(!$AudioPlayers/Magnet.playing):
			$AudioPlayers/Magnet.play()

		x_factor = (2 if(Input.is_action_pressed("magnet_attract")) else 1) * 3000/(global_position.x-current_raycast.get_collision_point().x)
		y_factor = (2 if(Input.is_action_pressed("magnet_attract")) else 1) * 2000/(global_position.y-current_raycast.get_collision_point().y)
		
		if(x_factor>1000):
			x_factor = INF
		elif(x_factor<-1000):
			x_factor = -INF
		if(y_factor>1000):
			y_factor = INF
		elif(y_factor<-1000):
			y_factor = -INF
		
		
		if(Input.is_action_pressed("magnet_repel")):
			magnet_dir = 1
		elif(Input.is_action_pressed("magnet_attract")):
			magnet_dir = -1
		
		#Thanks to popcar2 for the tilemap baking :)
		if(current_raycast.is_colliding() && current_raycast.get_collider() is StaticBody2D && current_raycast.get_collider().name != "NonMagnetable"):
			if(current_raycast.get_collider().name == "MagnetBomb" && current_raycast.get_collider().timer.time_left == 0):
				current_raycast.get_collider().timer.start()
			
			if(x_factor == INF || x_factor == -INF):
				velocity.y += y_factor * magnet_dir
			else:
				velocity.x += x_factor * magnet_dir
		
		elif(current_raycast.is_colliding() && current_raycast.get_collider() is RigidBody2D && !current_raycast.get_collider().get_child(2).has_overlapping_bodies()):
			var dist = (global_position - current_raycast.get_collider().global_position)
			current_raycast.get_collider().apply_central_force(Vector2((-1 if dist.x > 0 else 1) * 1500 * magnet_dir if x_factor != INF && x_factor != -INF else 0, (-1 if dist.y > 0 else 1) * 2000 * magnet_dir if y_factor != INF && y_factor != -INF else 0))
	else:
		$AudioPlayers/Magnet.stop()
	
	if(velocity.x > 1000):
		velocity.x = 1000
	elif(velocity.x < -1000):
		velocity.x = -1000
	if(velocity.y > 750):
		velocity.y = 750
	elif(velocity.y < -750):
		velocity.y = -750
	
	
	move_and_slide()
	$"../UI".get_child(0).get_child(1).value = magnet_power
	
	Globals.player_pos = global_position


func entered_elevator():
	$Skeleton2D.visible = false
	can_float = true
	
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)
	
	var move_up = get_tree().create_tween()
	move_up.tween_property($".","position",global_position + Vector2(0,-1000),1)
	
	await move_up.finished
	
	get_tree().change_scene_to_packed(next_scene)


func dead():
	if(!is_dead):
		is_dead = true
		
		$DeathBuffer.start()
		
		$AudioPlayers/Hit.play()
		
		
		set_collision_layer_value(1, false)
		
		can_move = false
		can_float = true
		
		velocity = Vector2.ZERO
		
		$AnimationPlayer.play("dead")
		
		$Timer2.start()
		await $Timer2.timeout
		
		$CPUParticles2D.emitting = true
		
		$Timer.start()
		await $Timer.timeout
		
		$Skeleton2D.rotation = 0
		$Skeleton2D/Torso/Head/Sprite2D.frame = 4
		position = Vector2(startX,startY)
		
		for i in $ResetArea.get_overlapping_bodies():
			if(i.position != i.startPos):
				if(i is CharacterBody2D):
					i.velocity = Vector2.ZERO
					i.aggro = false
					i.get_child(5).stop()
				elif(i is RigidBody2D):
					i.linear_velocity = Vector2.ZERO
				i.position = i.startPos
		
		set_collision_layer_value(1, true)
		can_move = true
		can_float = false


func set_checkpoint(x, y):
	startX = x
	startY = y


func _on_death_buffer_timeout():
	is_dead = false
