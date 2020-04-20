extends AudioStreamPlayer2D

var SFX_path

func start():
	stream = load(SFX_path)
	play()

func _process(delta):
	if (!playing):
		print(SFX_path)
		queue_free()
