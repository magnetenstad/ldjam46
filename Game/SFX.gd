extends AudioStreamPlayer2D

var SFX_path

func start():
	stream = load(SFX_path)
	play()

func _process(delta):
	if (!playing):
		queue_free()
