extends KinematicBody2D

var velocity = Vector2()
var grav = 300
var jump = 100
var spd_max = 80
var direction = 1
var seconds_alive = 0

func _ready():
	$"Particles2D".emitting = true

func _physics_process(delta):
	seconds_alive += delta
	# gravity and movement input
	if seconds_alive < 2:
		move_and_slide(velocity, Vector2(0, -1))
	
		if get_slide_count():
			var coll = get_slide_collision(0).collider
			if coll is KinematicBody2D and "Enemy" in coll.name:
				coll.queue_free()
				seconds_alive = 2
			if coll.name == "TileMap":
				var pos = coll.world_to_map(position)
				if coll.burn(pos) or coll.burn(pos + Vector2(direction, 0)) or coll.burn(pos + Vector2(0, 1)):
					seconds_alive = 2
			if coll.name == "Player":
				coll.health += 0.1
				seconds_alive = 2
			
		if is_on_floor():
			velocity.y = -jump
			$"/root/Main/AudioManager".play_sound("fire_lit", get_position())
		
		if is_on_wall():
			direction *= -1
			$"/root/Main/AudioManager".play_sound("fire_lit", get_position())
			
		velocity.x = spd_max * direction
		velocity.y += grav * delta
		
	elif seconds_alive > 3:
		queue_free()
	else:
		velocity.x = 0
		velocity.y = 0
		$"Particles2D".emitting = false
		$"CollisionShape2D".disabled = true
		$"Light2D".visible = false
