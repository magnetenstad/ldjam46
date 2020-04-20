extends Sprite

const WATER_DROPLET = preload("res://WaterDroplet.tscn")
var timer = 0

func _ready():
	pass

func _process(delta):
	timer += delta
	if(timer > 3):
		timer = 0
		var water_droplet = WATER_DROPLET.instance()
		add_child_below_node(self, water_droplet)
