extends Control

var typer_list = ["Typer1"]
var typer_active = 0

signal command_typed
signal tab_console

func _ready():
	find_node(typer_list[typer_active]).activate_selected(true)
	emit_signal('tab_console', typer_active)

func _input(event):
	if event is InputEventKey and event.pressed:
		# tab
		if event.scancode == KEY_TAB:
			_tab_active()

func set_typer_count(count):
	for i in range(1, count):
		typer_list.append("Typer" + str(i+1))


func set_input(new_text):
	set_input_specific(new_text, typer_active)


func set_input_specific(new_text, typer):
	find_node(typer_list[typer]).set_text(new_text)

func set_damage_typer(typer, damaged):
	find_node(typer_list[typer]).set_damage(damaged)

func _tab_active():
	# deactivate this one
	find_node(typer_list[typer_active]).activate_selected(false)
	
	# advance to next console
	typer_active += 1
	if typer_active >= typer_list.size():
		typer_active = 0
	
	# activate next one
	set_input(find_node(typer_list[typer_active]).get_text())
	find_node(typer_list[typer_active]).activate_selected(true)
	emit_signal('tab_console', typer_active)


func _command_typed(typer_n, text):
	emit_signal('command_typed', typer_n, text)
	pass
