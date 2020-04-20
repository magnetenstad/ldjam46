extends Control

var seen_stories = []


# Called when the node enters the scene tree for the first time.
func play(story_name):
	var story
	if story_name == "story_begin":
		story = "You must visit your grandma, as she is dying."
		
	elif story_name == "story_fiery_cavern":
		story = "To get to her, you must pass \nthrough the fiery cavern."
		
	elif story_name == "story_warcrimes":
		story = "Someone must have comitted horrible\nwar crimes here. I can feel it."
		
	elif story_name == "sss":
		story = "b"
		
	elif story_name == "sss":
		story = "b"
		
	elif story_name == "sss":
		story = "b"
		
	elif story_name == "a":
		story = "b"
		
	if not story_name in seen_stories:
		$"Timer".start()
		$"StoryText".text = story
		visible = true
		seen_stories.append(story_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	visible = false
