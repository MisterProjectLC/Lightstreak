extends "res://Mini Scenes/Main/GameTyper.gd"

func activate_selected(active):
	_active = active
	
	if active:
		$Selected.show()
	else:
		$Selected.hide()
		_caret_toggle(false)


func input_function(event):
	# accept Enter even when inactive
	if event is InputEventKey and event.pressed and !_active and event.scancode == KEY_ENTER:
		emit_signal("command_typed", id, _actual_text)
		set_text('')
	
	.input_function(event)
