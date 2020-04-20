extends KinematicBody2D

var velocity = Vector2()
var acc = 400
var grav = 300
var jump = 150
var spd_max = 80
var is_dead = false
var burns = []
onready var gameover_message = $"/root/Main/World/Player/Camera2D/Control"
onready var audio = $"Audio"
var FIREBALL = load("res://Fireball.tscn")
var bonfire
var last_checkpoint_position = Vector2(0, 0)
var last_mouse_pos = Vector2()
var tiles_removed_list = []
var flammable = [0, 1]

var health = 1

var enemies_in_range = []

func image_set_flip(flip):
	get_node("Sprite").set_flip_h(flip)

func _process(delta):
	if bonfire:
		health = 1
		if (last_checkpoint_position - position).length() > 128:
			tiles_removed_list = []
		if (last_checkpoint_position - position).length() > 4:
			audio.play()
		last_checkpoint_position = position
	var light_factor = 1 - (clamp(get_position().y, 200, 300) - 200) / 100
	if(light_factor == 1):
		health = 1
	$"../CanvasModulate".color = Color(0.0 + 1 * light_factor, 0.0 + 1 * light_factor, 0.0 + 1 * light_factor)

func _physics_process(delta):
	
	# respawn to checkpoint

	if Input.is_key_pressed(KEY_R):
		for tile in tiles_removed_list:
			$"/root/Main/World/TileMap".set_cell(tile[0], tile[1], tile[2])
			$"/root/Main/World/TileMap".firemap.set_cell(tile[0], tile[1], -1)
		$"/root/Main/World/TileMap".burns = []
		if position != last_checkpoint_position or health == 0:
			position = last_checkpoint_position
			health = 1
			audio.play()
			is_dead = false

	# gravity and movement input
	
	velocity.y += grav * delta

	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - acc * delta, -spd_max)
		image_set_flip(true)
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + acc * delta, spd_max)
		image_set_flip(false)
	else:
		velocity.x *= 0.9
	
	# move
	if not is_dead:
		velocity = move_and_slide(velocity, Vector2(0, -1))

	# get cell

	var tilemap = $"/root/Main/World/TileMap"
	var pos = tilemap.world_to_map(position)
	var cell = tilemap.get_cell(pos.x, pos.y)

	# climb and jump

	if Input.is_action_pressed("ui_up"):
		if cell == tilemap.TILE.LADDER:
			velocity.y = min(velocity.y, -jump/3)
		elif is_on_floor():
			velocity.y = -jump
	
	# fuel
	
	if cell == tilemap.TILE.FUEL:
		tilemap.set_cell(pos.x, pos.y, -1)
		tiles_removed_list.append([pos.x, pos.y, cell])
		health = 1
		audio.play()
	
	# water
	
	if cell == tilemap.TILE.WATER:
		health = 0
		
	# set fire

	var direction = -(int(get_node("Sprite").is_flipped_h())*2-1) # 1: left, 0: right

	# shoot fireball

	var world = $"/root/Main/World"

	if Input.is_action_just_pressed("ui_select") and health > 0.1:
		var fireball = FIREBALL.instance()
		world.add_child(fireball)
		fireball.direction = direction
		fireball.position = position + Vector2(direction * 16, 0)
		health -= 0.1

	# slime slukker fakkel

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == null:
			continue
		if collision.collider.name == "Enemy":
			health = 0
		if collision.collider.name == "WaterDroplet":
			health = 0
			collision.collider.queue_free()

	health = max(0, health - 0.05 * delta)

	if health <= 0:
		gameover_message.show()
		is_dead = true
	else:
		gameover_message.hide()
		
	# pick up fuel
	
	
	tiles_removed_list

func _on_AttackArea_body_entered(body):
	if(body.name == "Enemy"):
		enemies_in_range.append(body)

func _on_AttackArea_body_exited(body):
	if(body.name == "Enemy"):
		for enemy in enemies_in_range:
			if(enemy == body):
				enemies_in_range.erase(body)
