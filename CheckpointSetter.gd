extends Area2D

func _ready():
	$AnimationPlayer.play("pre_checkpoint")


func _on_body_entered(body):
	body.set_checkpoint(position.x,position.y)
	if($AnimationPlayer.current_animation != "checkpoint_activated" && !$Jingle.playing):
		$Jingle.play()
		$AnimationPlayer.play("checkpoint_get")
		$AnimationPlayer.queue("checkpoint_activated")
