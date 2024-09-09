extends CharacterBody2D


var aggro = false
@export var ghost: PackedScene 
@export var startPos:Vector2 = position

func _ready():
	startPos = position

func _physics_process(delta):
	if(Globals.player_pos.distance_to(startPos)>800):
		aggro = false
		$DashTimer.stop()
	
	if(velocity.x > 0 || velocity.y > 0):
		velocity *= 0.95
	
	if aggro && $DashTimer.time_left == 0:
		$DashTimer.start()
		
	move_and_slide()

func add_ghost():
	var ghost_scene = ghost.instantiate()
	$"../Container".add_child(ghost_scene)
	ghost_scene.set_property(position, ImageTexture.create_from_image(Image.load_from_file("res://Images/Enemies/Electricity Enemy V2 Particle.png" if $Idle.frame_coords == Vector2i(0,0) else "res://Images/Enemies/Electricity Enemy V2 Particle 2.png" if $Idle.frame_coords == Vector2i(1,0) else "res://Images/Enemies/Electricity Enemy V2 Particle 3.png" if $Idle.frame_coords == Vector2i(0,1) else "res://Images/Enemies/Electricity Enemy V2 Particle 4.png")))

func _on_ghost_timer_timeout():
	add_ghost()

func _on_timer_timeout():
	var dir = (Globals.player_pos - global_position).normalized()
	velocity = Vector2(1000*dir.x, 1000*dir.y)
	$Zap.play()

func _on_area_2d_body_entered(body):
	body.dead()

func _on_aggro_area_body_entered(body):
	aggro = true
