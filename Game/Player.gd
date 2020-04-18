extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80

func _physics_process(delta):
	velocity.y += grav * delta
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - acc * delta, -spd_max)
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + acc * delta, spd_max)
	else:
		velocity.x *= 0.9
	
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump
	
	velocity = move_and_slide(velocity)
	
