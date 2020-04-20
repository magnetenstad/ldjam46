extends Control

var seen_stories = []


# Called when the node enters the scene tree for the first time.
func play(story_name):
	var story
	if story_name == "story_begin":
		story = "Your mother just pushed you into the hole!\n She screams: KEEP THAT LIGHT ON!"
		
	elif story_name == "story_fiery_cavern":
		story = "Your mothers voice echoes: \nDo not press space! It will waste your light!"
		
	elif story_name == "story_warcrimes":
		story = "Someone must have comitted horrible\nwar crimes here. I can feel it."
		
	elif story_name == "story_bonfire":
		story = "Your grandpa once told you about bonfires. He said they give\neternal light, once lit."
		
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
