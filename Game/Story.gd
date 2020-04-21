extends Control

var seen_stories = []


# Called when the node enters the scene tree for the first time.
func play(story_name):
	var story
	if story_name == "story_begin":
		story = "Your mother just pushed you into the hole!\n She screams: KEEP THAT LIGHT ON!"
		
	elif story_name == "story_fiery_cavern":
		story = "Your mothers' voice echoes: \nDo not press space! It will waste your light!"
		
	elif story_name == "story_warcrimes":
		story = "Someone must have comitted horrible\nwar crimes here. I can feel it."
		
	elif story_name == "story_bonfire":
		story = "Your grandpa once told you about bonfires. He said they give\neternal light, once lit."
		
	elif story_name == "story_prank":
		story = "Looks like you got pranked.\nNothing is here."
		
	elif story_name == "story_stairs":
		story = "Who built these stairs? What a dumb question.\nWho builds anything, ever?"
		
	elif story_name == "story_travellers":
		story = "Someone must have been here before."
		
	elif story_name == "story_trap":
		story = "Your grandpa would have told you to immediately\nturn around from here."
		
	elif story_name == "story_house":
		story = "Some fool built a house here.\nBetter burn it."
		
	elif story_name == "story_houses":
		story = "Someone built a huge mountain of wooden planks.\nDid they really think it would last?"
		
	elif story_name == "story_houses2":
		story = "It did not last. You successfully \nburnt down every last one of the planks."
		
	elif story_name == "story_pre_end":
		story = "Could there be anything on the other side?"
		
	elif story_name == "story_end":
		story = "Could there be anything on the other side ... (you won)"
		$"/root/Main/World/Player".game_ended = true
	elif story_name == "story_sisyphus":
		story = "Some would say you are happy now."
		$"/root/Main/World/CanvasLayer/Achievement".get("Sisyphus")
		
	else:
		story = "lbank"
		
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
