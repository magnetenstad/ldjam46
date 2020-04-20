extends Control

 

var achieved = []

 


# Called when the node enters the scene tree for the first time.
func get(achievement):
	if not achievement in achieved:
		$"Timer".start()
		$"AchievedText".text = achievement
		visible = true
		achieved.append(achievement)

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

 


func _on_Timer_timeout():
	visible = false
