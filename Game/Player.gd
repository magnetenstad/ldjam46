extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var burns = []
onready var gameover_message= $"/root/Main/World/Player/Camera2D/Control"
onready var audio = $"Audio"
var bonfire
var last_checkpoint_position = Vector2(0, 0)
var last_mouse_pos = Vector2()

var flammable = [0, 1]

var health = 1

var enemies_in_range = []

func image_set_flip(flip):
	get_node("Sprite").set_flip_h(flip)
	
	
func _on_ready():
	pass

func _process(delta):
	if(bonfire):
		health = 1
		if (last_checkpoint_position - position).length() > 4:
			audio.play()
		last_checkpoint_position = position
	var light_factor = (max(min((float(150) - get_position().y), float(50)), float(0)) / float(50))
	$"../CanvasModulate".color = Color(0.0 + 1 * light_factor, 0.0 + 1 * light_factor, 0.0 + 1 * light_factor)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		last_mouse_pos = (get_global_mouse_position() - position).normalized() * 32
		var buffered_enemies_in_range = enemies_in_range + []
		for enemy in buffered_enemies_in_range:
			enemy.queue_free()
		
func _draw():
	last_mouse_pos = lerp(last_mouse_pos, Vector2(), 0.05)
	draw_line(Vector2(), last_mouse_pos, Color(1, 1, 1), 2)
	
func _physics_process(delta):
	update()
	velocity.y += grav * delta
	
	if Input.is_key_pressed(KEY_A):
		velocity.x = max(velocity.x - acc * delta, -spd_max)
	elif Input.is_key_pressed(KEY_D):
		velocity.x = min(velocity.x + acc * delta, spd_max)
	else:
		velocity.x *= 0.9
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if velocity.x > 0:
		image_set_flip(false)
	if velocity.x < 0:
		image_set_flip(true)
	
	var tilemap = $"/root/Main/World/TileMap"
	var firemap = $"/root/Main/World/FireTileMap"
	var pos = tilemap.world_to_map(position)
	var cell = tilemap.get_cell(pos.x, pos.y)
	
	# climb and jump
	if cell == 9 and Input.is_key_pressed(KEY_W):
		velocity.y = -jump/3
	elif is_on_floor() and Input.is_key_pressed(KEY_W):
		velocity.y = -jump
	# respawn to checkpoint
	
	if Input.is_key_pressed(KEY_R):
		if position != last_checkpoint_position or health == 0:
			position = last_checkpoint_position
			jump = 150
			spd_max = 80
			health = 1
			audio.play()
	
	# set fire
	
	var direction = -(int(get_node("Sprite").is_flipped_h())*2-1) # 1: left, 0: right
								
	if health > 0 and Input.is_key_pressed(KEY_S):
		var firepos = Vector2(-42069, -42069)
		if tilemap.get_cell(pos.x + direction, pos.y) in flammable:
			firepos = Vector2(pos.x+direction, pos.y)
		elif tilemap.get_cell(pos.x, pos.y-1) in flammable:
			firepos = Vector2(pos.x, pos.y-1)
		elif tilemap.get_cell(pos.x, pos.y+1) in flammable:
			firepos = Vector2(pos.x, pos.y+1)
			
		if firepos != Vector2(-42069, -42069):
			tilemap.set_cell(firepos.x, firepos.y, 8)
			firemap.set_cell(firepos.x, firepos.y, 8)
			burns.append([floor(rand_range(2, 60)), firepos])
			health = 1
			audio.play()
		
	# fire spreading
	
	for i in range(burns.size()):
		var burn = burns[i]
		pos = burn[1]
		burn[0] -= 1
		
		if burn[0] <= 0:
			firemap.set_cell(pos.x, pos.y, -1)
			tilemap.set_cell(pos.x, pos.y, -1)
			burns.remove(i)
			break
		else:
			var others = [Vector2(pos.x - 1, pos.y), Vector2(pos.x, pos.y - 1), Vector2(pos.x + 1, pos.y), Vector2(pos.x, pos.y + 1)]
			
			for other in others:
				cell = tilemap.get_cell(other.x, other.y)
				if burn[0] == 1 and cell in flammable:
					tilemap.set_cell(other.x, other.y, 8)
					firemap.set_cell(other.x, other.y, 8)
					burns.append([floor(rand_range(2, 60)), other])
					audio.play()

	var world = $"/root/Main/World"
	
	# slime slukker fakkel
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Enemy":
			health = 0
			
	health = max(0, health - 0.05 * delta)
	if health == 0:
		gameover_message.show()
		spd_max = 0
		jump = 0
	else:
		gameover_message.hide()

	


func _on_AttackArea_body_entered(body):
	if(body.name == "Enemy"):
		enemies_in_range.append(body)


func _on_AttackArea_body_exited(body):
	if(body.name == "Enemy"):
		for enemy in enemies_in_range:
			if(enemy == body):
				enemies_in_range.erase(body)
