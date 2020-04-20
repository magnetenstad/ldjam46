extends KinematicBody2D

var velocity = Vector2()
var grav = 300
var jump = 100
var spd_max = 80
var direction = 1

func _physics_process(delta):

	# gravity and movement input
	
	velocity.y += grav * delta

	move_and_slide(velocity, Vector2(0, -1))

	if get_slide_count():
		var coll = get_slide_collision(0).collider
		if coll is KinematicBody2D and coll.name == "Enemy":
			coll.queue_free()
			queue_free()
		if coll.name == "TileMap":
			var pos = coll.world_to_map(position)
			if coll.burn(pos) or coll.burn(pos + Vector2(direction, 0)) or coll.burn(pos + Vector2(1, 0)):
				queue_free()
		
	if is_on_floor():
		velocity.y = -jump
	
	if is_on_wall():
		direction *= -1
	
	velocity.x = spd_max * direction
	
