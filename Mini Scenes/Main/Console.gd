extends Control

var typer_list
var typer_active = 0

signal typer_updated
signal command_typed
signal tab_console

func _ready():
	typer_list = [get_node("Typer1")]
	typer_list[typer_active].activate_selected(true)
	emit_signal('tab_console', typer_active)

func _input(event):
	if event is InputEventKey and event.pressed:
		# tab
		if event.scancode == KEY_TAB:
			_tab_active(true)
		
		# tab
		if event.scancode == KEY_CONTROL:
			_tab_active(false)


func set_typer_count(count):
	for i in range(1, count):
		typer_list.append(get_node("Typer" + str(i+1)))


func set_input(new_text):
	set_input_specific(new_text, typer_active)


func set_input_specific(new_text, typer):
	typer_list[typer].set_text(new_text)

func set_damage_typer(typer, damaged):
	typer_list[typer].set_damage(damaged)

func _tab_active(forward):
	# deactivate this one
	typer_list[typer_active].activate_selected(false)
	
	# advance to next console
	if forward:
		typer_active += 1
		if typer_active >= typer_list.size():
			typer_active = 0
	else:
		typer_active -= 1
		if typer_active < 0:
			typer_active = typer_list.size()-1
	
	# activate next one
	set_input(typer_list[typer_active].get_text())
	typer_list[typer_active].activate_selected(true)
	emit_signal('tab_console', typer_active)
	emit_signal("typer_updated", typer_list[typer_active].get_text())


func _command_typed(typer_n, text):
	emit_signal('command_typed', typer_n, text)


func _update_outlines(text):
	emit_signal("typer_updated", text)
