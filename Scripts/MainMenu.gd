extends Control

var moving_children = {
	
}
var fading_children = {
	
}

var outlines = ["Play", "Powers_List", "Options", "Credits", "Quit",
				"OptionsMenu/Music", "OptionsMenu/Sounds", "OptionsMenu/Back",
				"Stages/Back", "Stages/Page 1/P1", "Stages/Page 1/P2",
				"Stages/Page 1/P3", "Stages/Page 1/P4", "Stages/Page 1/P5",
				"Stages/Page 2/P6", "Stages/Page 2/P7", "Stages/Page 2/P8",
				"Stages/Page 2/P9", "Stages/Page 2/P10"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(outlines.size()):
		outlines[i] = find_outline(outlines[i])
	
	if Global.get_lightstreak_typed():
		Audio.play_music(Audio.menu_theme)
		$Typer.rect_position = Vector2(117, 641)
		$Stages.rect_position = Vector2(10, 192)
		$Title.set("custom_colors/font_color", Color(1, 1, 1, 1))
		pass

func find_outline(text):
	text = "./" + text + "/Outline"
	return get_node(text)

func _process(_delta):
	for child in moving_children.keys():
		var object = find_node(child)
		if object.rect_position != moving_children[child]:
			object.rect_position += 0.05*(moving_children[child] - object.rect_position)
			
	for child in fading_children.keys():
		var object = find_node(child)
		if object.modulate.a != fading_children[child]:
			object.modulate.a += 0.05*(fading_children[child] - object.modulate.a)

func _command_typed(id, text):
	var args = text.rsplit(" ", false, 0)
	
	if (len(args) <= 0):
		return
	
	if (len(text) == 1 or len(text) == 2):
		text = "PLAY " + text
		args = text.rsplit(" ", false, 0)
	
	match(args[0]):
		"LIGHTSTREAK":
			if !Global.get_lightstreak_typed():
				Audio.play_music(Audio.menu_theme)
				moving_children['Typer'] = Vector2(117, 641)
				pull_menu()
				fading_children['GameBackground'] = 1
				$Title.set("custom_colors/font_color", Color(1, 1, 1, 1))
				Global.set_lightstreak_typed(true)
				
		"PLAY":
			if !Global.get_lightstreak_typed():
				return

			if len(args) == 1:
				pushback_menu()
				push_other_menus()
				moving_children['Stages'] = Vector2(10, 192)

			elif len(args) == 2:
				var chosen_phase = int(args[1])
				if chosen_phase >= 1 and chosen_phase <= 20:
					Global.set_current_phase(chosen_phase)
					get_tree().change_scene("res://Scenes/Main.tscn")
					
		"OPTIONS":
			if !Global.get_lightstreak_typed():
				return

			pushback_menu()
			push_other_menus()

			moving_children['OptionsMenu'] = Vector2(10, 192)
			
		"MUSIC":
			if len(args) == 2:
				var chosen_volume = int(args[1])
				if chosen_volume >= 0 and chosen_volume <= 100:
					Global.set_music_volume(chosen_volume)

		"SOUNDS":
			if len(args) == 2:
				var chosen_volume = int(args[1])
				print(chosen_volume)
				if chosen_volume >= 0 and chosen_volume <= 100:
					Global.set_sounds_volume(chosen_volume)
					Audio.play_sound(Audio.laser)

		"BACK":
			if Global.get_lightstreak_typed():
				pull_menu()
				push_other_menus()
				
		"QUIT":
			get_tree().quit()

func _update_outlines(text):
	for outline in outlines:
		outline.update_text(text)

func push_other_menus():
	moving_children['Stages'] = Vector2(-810, 192)
	moving_children['OptionsMenu'] = Vector2(-810, 192)

func pull_menu():
	moving_children['Play'] = Vector2(10, 190)
	moving_children['Powers_List'] = Vector2(10, 260)
	moving_children['Options'] = Vector2(10, 330)
	moving_children['Credits'] = Vector2(10, 400)
	moving_children['Quit'] = Vector2(10, 470)

func pushback_menu():
	moving_children['Play'] = Vector2(800, 190)
	moving_children['Powers_List'] = Vector2(800, 260)
	moving_children['Options'] = Vector2(800, 330)
	moving_children['Credits'] = Vector2(800, 400)
	moving_children['Quit'] = Vector2(800, 470)
