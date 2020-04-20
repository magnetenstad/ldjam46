extends Node

const SFXCONST = preload("res://SFX.tscn")

func _ready():
	pass

func play_sound(name, position):
	var SFX = SFXCONST.instance()
	SFX.position = position
	add_child(SFX)
	SFX.SFX_path = "res://Assets/Audio/" + name + ".wav"
	SFX.start()
