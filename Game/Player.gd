extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burns = []

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

	if tilemap.get_cell(pos.x, pos.y) != -1 and Input.is_action_pressed("ui_down"):
		tilemap.set_cell(pos.x, pos.y, 8)
		burns.append([floor(rand_range(0, 60)), pos])

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
				var cell = tilemap.get_cell(other.x, other.y)
				if cell != -1 and cell != 8 and burn[0] == 20:
					tilemap.set_cell(other.x, other.y, 8)
					burns.append([floor(rand_range(0, 60)), other])
