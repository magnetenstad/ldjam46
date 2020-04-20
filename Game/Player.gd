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

var flammable = [0, 1]

var health = 1

var enemies_in_range = []

func image_set_flip(flip):
	get_node("Sprite").set_flip_h(flip)

func _process(delta):
	if bonfire:
		health = 1
		if (last_checkpoint_position - position).length() > 4:
			audio.play()
		last_checkpoint_position = position
	var light_factor = 1 - (clamp(get_position().y, 200, 300) - 200) / 100
	health = max(health, light_factor)
	$"../CanvasModulate".color = Color(0.0 + 1 * light_factor, 0.0 + 1 * light_factor, 0.0 + 1 * light_factor)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and not is_dead:
		last_mouse_pos = (get_global_mouse_position() - position).normalized() * 32
		var buffered_enemies_in_range = enemies_in_range + []
		for enemy in buffered_enemies_in_range:
			enemy.queue_free()
		
func _draw():
	last_mouse_pos = lerp(last_mouse_pos, Vector2(), 0.05)
	draw_line(Vector2(), last_mouse_pos, Color(1, 1, 1), 2)
	
func _physics_process(delta):
	update()
	# respawn to checkpoint
	
	if Input.is_key_pressed(KEY_R):
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
		if cell == 9:
			velocity.y = -jump/3
		elif is_on_floor():
			velocity.y = -jump
	
	# set fire
	
	var direction = -(int(get_node("Sprite").is_flipped_h())*2-1) # 1: left, 0: right
	
	if health > 0 and (Input.is_action_pressed("ui_down")):
		if tilemap.burn(Vector2(pos.x + direction, pos.y)) or tilemap.burn(Vector2(pos.x, pos.y + 1)) or tilemap.burn(Vector2(pos.x, pos.y - 1)):
			health = 1
			
	# shoot fireball
	
	var world = $"/root/Main/World"
	
	if Input.is_action_just_pressed("ui_select"):
		var fireball = FIREBALL.instance()
		world.add_child(fireball)
		fireball.direction = direction
		fireball.position = position + Vector2(direction * 16, 0)

	# slime slukker fakkel
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
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

func _on_AttackArea_body_entered(body):
	if(body.name == "Enemy"):
		enemies_in_range.append(body)

func _on_AttackArea_body_exited(body):
	if(body.name == "Enemy"):
		for enemy in enemies_in_range:
			if(enemy == body):
				enemies_in_range.erase(body)
