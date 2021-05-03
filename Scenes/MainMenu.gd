extends Control

var moving_children = {
	
}
var fading_children = {
	
}

var outlines = ["Play", "Play_Multi", "Options", "Credits", "Quit",
				"OptionsMenu/Music", "OptionsMenu/Sounds", "OptionsMenu/Back",
				"OptionsMenu/Lang", "PlayMulti/Back", "PlayMulti/Hero", 
				"PlayMulti/Villain", "Looking/Back",
				"Stages/Back", "Stages/Page 1/P1", "Stages/Page 1/P2",
				"Stages/Page 1/P3", "Stages/Page 1/P4", "Stages/Page 1/P5",
				"Stages/Page 2/P6", "Stages/Page 2/P7", "Stages/Page 2/P8",
				"Stages/Page 2/P9", "Stages/Page 2/P10", "Stages/Page 3/P11",
				"Stages/Page 3/P12", "Stages/Page 3/P13", "Stages/Page 3/P14",
				"Stages/Page 3/P15", "Stages/Page 4/P16", "Stages/Page 4/P17",
				"Stages/Page 4/P18"]

const BASE_Y = -260
const INCREMENT = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	Alphabet.menu_reset()
	$"Stages/Page 4/Stage 18/AnimationPlayer".play("Stage18")
	
	for i in range(outlines.size()):
		outlines[i] = find_outline(outlines[i])
	
	if Global.get_lightstreak_typed():
		Audio.play_music(Audio.menu_theme)
		$Typer.margin_left = -257
		$Typer.margin_top = 680
		$Stages.margin_left = -367
		$Stages.margin_top = BASE_Y
		$Typer.set_font_size(50)
		$Title.set("custom_colors/font_color", Color(1, 1, 1, 1))
		$GameBackground.set_modulate(Color(1, 1, 1, 1))
		pass


func find_outline(text):
	text = "./" + text + "/Outline"
	return get_node(text)


func _physics_process(delta):
	for child in moving_children.keys():
		var object = find_node(child)
		if object.margin_left != moving_children[child][0] or object.margin_top != moving_children[child][1]:
			object.margin_left += 0.05*(moving_children[child][0] - object.margin_left)
			object.margin_top += 0.05*(moving_children[child][1] - object.margin_top)
			
	for child in fading_children.keys():
		var object = find_node(child)
		if object.modulate.a != fading_children[child]:
			object.modulate.a += 0.05*(fading_children[child] - object.modulate.a)


func _command_typed(_id, text):
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
				moving_children['Typer'] = [-257, 680]
				$Typer.set_font_size(50)
				$Typer/Text.rect_position += Vector2(0, 10)
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
				moving_children['Stages'] = [-367, BASE_Y]
			elif len(args) == 2:
				var chosen_phase = int(args[1])
				if chosen_phase >= 1 and chosen_phase <= 20:
					Global.set_current_phase(chosen_phase)
					get_tree().change_scene("res://Scenes/Main.tscn")
		
		"PLAY_MULTI":
			if !Global.get_lightstreak_typed():
				return
			if len(args) == 1:
				pushback_menu()
				push_other_menus()
				moving_children['PlayMulti'] = [-367, BASE_Y]
		
		"HERO":
			if !Global.get_lightstreak_typed():
				return
			
			if len(args) == 2:
				Network.create_server(args[1])
				pushback_menu()
				push_other_menus()
				moving_children['Looking'] = [-367, BASE_Y]
		
		"VILLAIN":
			if !Global.get_lightstreak_typed():
				return
			
			if len(args) == 2:
				Network.connect_to_server(args[1])
				pushback_menu()
				push_other_menus()
				moving_children['Looking'] = [-367, BASE_Y]
		
		"OPTIONS":
			if !Global.get_lightstreak_typed():
				return
			pushback_menu()
			push_other_menus()
			moving_children['OptionsMenu'] = [-367, BASE_Y]

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
		
		"LANG":
			if len(args) == 2:
				var dict = {"EN":2, "PT":3, "DE":4}
				if args[1] in dict.keys():
					Global.set_language(dict[args[1]])

		"BACK":
			if Global.get_lightstreak_typed():
				pull_menu()
				push_other_menus()
				#Network.close_connection()
		
		"CREDITS":
			get_tree().change_scene("res://Scenes/Credits.tscn")
		
		"QUIT":
			get_tree().quit()


func _update_outlines(text):
	for outline in outlines:
		outline.update_text(text)


func push_other_menus():
	moving_children['PlayMulti'] = [-1188, BASE_Y]
	moving_children['Looking'] = [-1188, BASE_Y]
	moving_children['Stages'] = [-1188, BASE_Y]
	moving_children['OptionsMenu'] = [-1188, BASE_Y]


func pull_menu():
	moving_children['Play'] = [-380, BASE_Y]
	moving_children['Play_Multi'] = [-380, BASE_Y+ INCREMENT]
	moving_children['Options'] = [-380, BASE_Y+ INCREMENT*2]
	moving_children['Credits'] = [-380, BASE_Y+INCREMENT*3]
	moving_children['Quit'] = [-380, BASE_Y+INCREMENT*4]


func pushback_menu():
	moving_children['Play'] = [420, BASE_Y]
	moving_children['Play_Multi'] = [420, BASE_Y+INCREMENT]
	moving_children['Options'] = [420, BASE_Y+INCREMENT*2]
	moving_children['Credits'] = [420, BASE_Y+INCREMENT*3]
	moving_children['Quit'] = [420, BASE_Y+INCREMENT*4]
