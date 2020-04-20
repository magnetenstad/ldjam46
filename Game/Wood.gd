extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SFXCONST = preload("res://SFX.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	var player = $"/root/Main/World/Player"
	
	if position.distance_to(player.position) < 16:
		$"/root/Main/AudioManager".play_sound("pickup", get_position())
		player.health = 1
		queue_free()
		
