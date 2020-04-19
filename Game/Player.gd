extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burns = []

var flammable = [0, 1, 2]

func point_distance(x0, y0, x1, y1):
	return sqrt(pow(x1-x0, 2) + pow(y1-y0, 2))
	
func _on_ready():
	 pass

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
	
	var tilemap = $"/root/Main/World/TileMap"
	var pos = tilemap.world_to_map(position)
	pos.y += 1
	
	# set fire
	
	var cell = tilemap.get_cell(pos.x, pos.y)
	if cell in flammable and Input.is_action_pressed("ui_down"):
		tilemap.set_cell(pos.x, pos.y, 8)
		burns.append([floor(rand_range(0, 60)), pos])
	
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
				if cell in flammable and burn[0] == 20:
					tilemap.set_cell(other.x, other.y, 8)
					burns.append([floor(rand_range(0, 60)), other])
	
	# jump on enemy
	
	var enemy = $"/root/Main/World/Enemy"
	
	var collision = get_slide_collision(0)
	
	if collision and collision.collider == enemy:
		enemy.queue_free()
