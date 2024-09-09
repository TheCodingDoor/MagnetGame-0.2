extends RigidBody2D

@export var startPos:Vector2

func _ready():
	startPos = position


func _on_body_entered(body):
	$AudioStreamPlayer2D.play()
