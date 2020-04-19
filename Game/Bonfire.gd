extends Area2D


func _on_Bonfire_body_entered(body):
	print(body.name)
	if(body.name == "Player"):
		$AnimatedSprite.visible = true
		$Light2D.enabled = true
