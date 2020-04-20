extends Area2D


func _on_Bonfire_body_entered(body):
	if(body.name == "Player"):
		if(!$AnimatedSprite.visible):
			$"/root/Main/AudioManager".play_sound("bonfire", get_position())
		$AnimatedSprite.visible = true
		$Light2D.enabled = true
		if(!body.bonfire):
			$"/root/Main/AudioManager".play_sound("fire_lit", get_position())
		body.bonfire = true


func _on_Bonfire_body_exited(body):
	if(body.name == "Player"):
		body.bonfire = false
