extends Node2D
onready var audio = $"/root/Main/World/Player/Audio"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	var player = $"/root/Main/World/Player"
	
	if position.distance_to(player.position) < 16:
		audio.play()
		player.health = 1
		queue_free()
		
