extends "res://Scenes/Main.gd"

func ready():
	Audio.play_music(Audio.phase_themes[Global.get_current_phase()-1])
	_weapon_list = [get_node('LaserTitle'), get_node('SphereTitle'), 
					get_node('ShockTitle'), get_node('MagnetTitle'),
					get_node('MissileTitle'), get_node('BombTitle'), 
					get_node('MachineTitle'), get_node('PushTitle'), 
					get_node('LightTitle')]
	
	# setup consoles
	$Console.set_typer_count(3)
	
	# setup cannon
	for i in range(3):
		_cannon_list.append(get_node("Cannon" + str(i+1)))
		_cannon_list[i].activate()
	_cannon_list[0].toggle_highlight(true)
	
	# setup weapon lists
	for i in range(1, 10):
		_weapon_list[i-1].set_visible(true)
	
	for w in range(len(_weapon_list)):
		var new_word = $LangSystem.get_word(_weapon_list[w].get_difficulty(), 
										Global.get_language())
		# if word is a repeat, try again
		while (1):
			var repeats = false
			for i in range(9):
				if _weapon_list[i] != _weapon_list[w] and _weapon_list[i].get_text() == new_word:
					new_word = $LangSystem.get_word(_weapon_list[i].get_difficulty(), Global.get_language())
					repeats = true
					break
				
			if repeats == false:
				break
			
		_weapon_list[w].set_text(new_word)
	
