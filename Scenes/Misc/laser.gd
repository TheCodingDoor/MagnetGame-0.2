#NOTE TO SELF BECAUSE I'LL PROBABLY FORGET THIS: IF THE LASERS ALL HAVE THE SAME HITBOX DESPITE HAVING DIFFERENT LENGTHS, MAKE EACH LASER LOCAL TO SCENE AND MAKE BOTH THE LASER NODE AND THE COLLISIONSHAPE2D HAVE UNIQUE SUBRESOURCES 

extends Node2D

@export var length: float = 0
@export var rotation_speed: float = 0


func _ready():
	$laser_beam.scale.x = length/128
	$head1.position.x = -length/2
	$head2.position.x = length/2
	$Area2D/CollisionShape2D.shape.size = Vector2(length,32)


func _process(_delta):
	rotation_degrees += rotation_speed


func _on_area_2d_body_entered(body):
	if(body == $"../../Player"):
		body.dead()
