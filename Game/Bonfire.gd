extends Area2D


var entered = false

func _on_Bonfire_body_entered(body):
	if(body.name == "Player"):
		if(!$AnimatedSprite.visible):
			$"/root/Main/AudioManager".play_sound("bonfire", get_position())
		if(!entered):
			$"/root/Main/AudioManager".play_sound("fire_lit", get_position())
			entered = true
		$AnimatedSprite.visible = true
		$Light2D.enabled = true
		body.bonfire = true


func _on_Bonfire_body_exited(body):
	if(body.name == "Player"):
		body.bonfire = false
		entered = false
