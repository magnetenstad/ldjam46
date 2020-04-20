extends TileMap

var flammable = [0, 1]
var burns = []
onready var firemap = $"/root/Main/World/FireTileMap"
onready var audio = $"/root/Main/World/Player/Audio"

func _ready():
	pass # Replace with function body.

func burn(pos):
	if get_cell(pos.x, pos.y) in flammable:
		$"/root/Main/World/Player".tiles_removed_list.append([pos.x, pos.y, get_cell(pos.x, pos.y)])
		set_cell(pos.x, pos.y, -1)
		firemap.set_cell(pos.x, pos.y, 8)
		burns.append([floor(rand_range(2, 60)), pos])
		audio.play()
		return true
	else:
		return false
	
func _process(delta):
	for i in range(burns.size()):
		var burn = burns[i]
		var pos = burn[1]
		burn[0] -= 1
		
		if burn[0] <= 0:
			firemap.set_cell(pos.x, pos.y, -1)
			burns.remove(i)
			break
		else:
			var others = [Vector2(pos.x - 1, pos.y), Vector2(pos.x, pos.y - 1), Vector2(pos.x + 1, pos.y), Vector2(pos.x, pos.y + 1)]
			
			for other in others:
				var cell = get_cell(other.x, other.y)
				if burn[0] == 1 and cell in flammable:
					$"/root/Main/World/Player".tiles_removed_list.append([other.x, other.y, cell])
					firemap.set_cell(other.x, other.y, 8)
					set_cell(other.x, other.y, -1)
					burns.append([floor(rand_range(2, 60)), other])
					audio.play()
	
