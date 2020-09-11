extends "res://Scenes/Main.gd"

func setup_title_replicate():
		# replicate text
	if _current_phase["REPLICATE_TEXT"] != 0:
		if _current_phase["INITIAL_TEXT"].left(6) == 'Light ':
			_title_list[_current_phase["REPLICATE_TEXT"]-1].set_text(_current_phase["INITIAL_TEXT"].lstrip("Light "))
		else:
			_title_list[_current_phase["REPLICATE_TEXT"]-1].set_text(_current_phase["INITIAL_TEXT"])
		
		typer_updated(_current_phase["INITIAL_TEXT"])


func setup_background():
	set_background(_current_phase["ARENA"])


func setup_console():
	.setup_console()
	$Console.set_input_specific(_current_phase["INITIAL_TEXT"], _cannon_count-1)


func summon_heylook():
	var new = heylook.instance()
	add_child(new)
	move_child(new, get_child_count()-1)
	new.rect_position.x = 9
	new.rect_position.y = 607
	connect('cannon_moved', new, 'start')
	connect('weapon_activated', new, 'destroy')
