extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burning = []

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
	var cell = tilemap.get_cell(pos.x, pos.y)

	if cell == 0 and Input.is_action_pressed("ui_down"):
		tilemap.set_cell(pos.x, pos.y, 8)
		burning.append(pos)
	
	if burning.size() > 0 and floor(rand_range(0, 60)) == 0:
		pos = burning[0]
		tilemap.set_cell(pos.x, pos.y, -1)
		burning.remove(0)
