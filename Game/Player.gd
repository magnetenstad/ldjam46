extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burns = []

var bonfire

var flammable = [0, 1, 2]

var health = 1

func point_distance(x0, y0, x1, y1):
	return sqrt(pow(x1-x0, 2) + pow(y1-y0, 2))

func image_set_flip(flip):
	get_node("Sprite").set_flip_h(flip)
	
func _on_ready():
	 pass

func _physics_process(delta):
	
	if(bonfire):
		health = 1
	
	velocity.y += grav * delta
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - acc * delta, -spd_max)
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + acc * delta, spd_max)
	else:
		velocity.x *= 0.9
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if velocity.x > 0:
		image_set_flip(false)
	if velocity.x < 0:
		image_set_flip(true)
		
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump
	
	var tilemap = $"/root/Main/World/TileMap"
	var pos = tilemap.world_to_map(position)
	pos.y += 1
	
	# set fire
	
	var cell = tilemap.get_cell(pos.x, pos.y)
	if health > 0 and cell in flammable and Input.is_action_pressed("ui_down"):
		tilemap.set_cell(pos.x, pos.y, 8)
		burns.append([floor(rand_range(1, 60)), pos])
		health = 1
		
	# fire spreading
	
	for i in range(burns.size()):
		var burn = burns[i]
		pos = burn[1]
		burn[0] -= 1
		
		if burn[0] <= 0:
			tilemap.set_cell(pos.x, pos.y, -1)
			burns.remove(i)
			break
		else:
			var others = [Vector2(pos.x - 1, pos.y), Vector2(pos.x, pos.y - 1), Vector2(pos.x + 1, pos.y), Vector2(pos.x, pos.y + 1)]
			
			for other in others:
				cell = tilemap.get_cell(other.x, other.y)
				if burn[0] == 1 and cell in flammable:
					tilemap.set_cell(other.x, other.y, 8)
					burns.append([floor(rand_range(1, 60)), other])

	var world = $"/root/Main/World"
	
	# jump on enemy
	
	if world.has_node("Enemy"):
		var enemy = $"/root/Main/World/Enemy"
		
		if get_slide_count():
			var collision = get_slide_collision(0)
			
			if collision and collision.collider == enemy:
				enemy.queue_free()
			
	# wood
	
	
	if world.has_node("Wood"):
		var wood = world.get_node("Wood")
		if point_distance(position.x, position.y, wood.position.x, wood.position.y) < 16:
			health = 1
			wood.queue_free()
	
	health = max(0, health - 0.1 * delta)	
