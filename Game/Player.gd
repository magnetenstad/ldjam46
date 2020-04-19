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

var enemies_in_range = []

func image_set_flip(flip):
	get_node("Sprite").set_flip_h(flip)
	
func _on_ready():
	 pass

func _process(delta):
	if(bonfire):
		health = 1
	var light_factor = (max(min((float(150) - get_position().y), float(50)), float(0)) / float(50))
	$"../CanvasModulate".color = Color(0.0 + 1 * light_factor, 0.0 + 1 * light_factor, 0.0 + 1 * light_factor)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var buffered_enemies_in_range = enemies_in_range + []
		for enemy in buffered_enemies_in_range:
			enemy.queue_free()

func _physics_process(delta):
	
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
	
	var tilemap = $"/root/Main/World/TileMap"
	var pos = tilemap.world_to_map(position)
	var cell = tilemap.get_cell(pos.x, pos.y)
	
	# climb and jump
	
	if cell == 9 and Input.is_action_pressed("ui_up"):
		velocity.y = -jump/4
	elif is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump
	
	pos.y += 1
	
	# set fire
	
	cell = tilemap.get_cell(pos.x, pos.y)
	if health > 0 and cell in flammable and Input.is_action_pressed("ui_down"):
		tilemap.set_cell(pos.x, pos.y, 8)
		burns.append([floor(rand_range(2, 60)), pos])
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
					burns.append([floor(rand_range(2, 60)), other])

	var world = $"/root/Main/World"
	
	# slime slukker fakkel
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Enemy":
			health = 0
			
	health = max(0, health - 0.05 * delta)	

	


func _on_AttackArea_body_entered(body):
	if(body.name == "Enemy"):
		enemies_in_range.append(body)


func _on_AttackArea_body_exited(body):
	if(body.name == "Enemy"):
		for enemy in enemies_in_range:
			if(enemy == body):
				enemies_in_range.erase(body)
