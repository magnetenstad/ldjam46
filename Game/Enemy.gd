extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burns = []
var target
var flammable = [0, 1, 2]

func _on_ready():
	pass

func _physics_process(delta):
	target = $"/root/Main/World/Player"
#
	velocity.y += grav * delta
#
#	if target.position.x < position.x:
#		velocity.x = max(velocity.x - acc * delta, -spd_max)
#	else:
#		velocity.x = min(velocity.x + acc * delta, spd_max)
#


	velocity.x = sin(OS.get_ticks_msec()/1000.0) * spd_max
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor() and target.position.y < position.y:
		velocity.y = -jump

	# slime slukker fakkel
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			$"../Player".health = 0
