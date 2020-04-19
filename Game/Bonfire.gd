extends Area2D


func _on_Bonfire_body_entered(body):
	if(body.name == "Player"):
		$AnimatedSprite.visible = true
		$Light2D.enabled = true
		body.bonfire = true


func _on_Bonfire_body_exited(body):
	if(body.name == "Player"):
		body.bonfire = false
