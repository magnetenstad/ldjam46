extends Node

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())
	OS.window_size = Vector2(1280, 720)
	OS.window_position = Vector2(300, 200)
	
