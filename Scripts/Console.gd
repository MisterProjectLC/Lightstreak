extends Control

var typer_list = ["Typer1"]
var typer_active = 0
var input = ""

signal command_typed
signal tab_console

func _ready():
	find_node(typer_list[typer_active]).activate_selected(true)
	emit_signal('tab_console', typer_active)
	
func set_typer_count(count):
	for i in range(1, count):
		typer_list.append("Typer" + str(i+1))

func _capital(kchar):
	if input.length() == 0:
		return kchar.to_upper()
	else:
		return kchar.to_lower()


func set_input(new_text):
	input = new_text
	find_node(typer_list[typer_active]).set_text(input)


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


func _input(event):
	if event is InputEventKey and event.pressed:
		# writable input
		if event.scancode == KEY_SPACE or (event.scancode >= KEY_A and event.scancode <= KEY_Z) or (event.scancode >= KEY_0 and event.scancode <= KEY_9):
			var kchar = OS.get_scancode_string(event.scancode)
			
			# checking alphabet
			if get_node("/root/Alphabet").get_letter(event.scancode) != null:
				kchar = get_node("/root/Alphabet").get_letter(event.scancode)
				
			# capitalization issues
			kchar = _capital(kchar)
			
			# append letter
			set_input(self.input + kchar)
			
		# backspace
		elif event.scancode == KEY_BACKSPACE:
			set_input(input.left(input.length()-1))
			
		# enter
		elif event.scancode == KEY_ENTER:
			emit_signal("command_typed", typer_active, input)
			set_input('')
		
		# tab
		elif event.scancode == KEY_TAB:
			_tab_active()
