extends KinematicBody2D

var grav = 300
var velocity = Vector2()
	
func _physics_process(delta):
	velocity.y += grav * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == null:
			continue
		if collision.collider.name == "Player":
			get_tree().get_root().find_node("Player", true, false).health = 0
		queue_free()
