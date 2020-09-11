extends Control

export var id = 0
var _actual_text = ''
var _display_text = ''
var _time = 0
var _caret_blink_rate = 0.53
var _caret_active = false
var _active = false

signal command_typed
signal typer_updated

# Caret -----------------------
func _process(delta):
	if _time > _caret_blink_rate:
		_caret_blinking()
		_time = 0
	else:
		_time += delta

func _caret_toggle(_toggle):
	_caret_active = _toggle
	set_display_text(_display_text)


func _caret_blinking():
	if _active == false:
		_caret_active = false
		return
	
	_caret_toggle(!_caret_active)
# ---------------------------------------


func input_function(event):
	if event is InputEventKey and event.pressed and _active:
		# writable input
		if (event.scancode in Alphabet.alphabet.keys() or 
		(event.scancode >= KEY_A and event.scancode <= KEY_Z) or 
		(event.scancode >= KEY_0 and event.scancode <= KEY_9)):
			var kchar = OS.get_scancode_string(event.scancode)
			var swapped = false
			
			# checking alphabet
			if get_node("/root/Alphabet").get_letter(event.scancode) != null:
				kchar = get_node("/root/Alphabet").get_letter(event.scancode)
				
				if !get_node("/root/Alphabet").is_special(kchar):
					swapped = true

			# capitalization issues
			if has_method('_capital'):
				kchar = _capital(kchar)
			
			set_actual_text(self._actual_text + kchar)
			
			# swapped
			if swapped:
				kchar = "[color=red]" + kchar + "[/color]"
			
			# append letter
			set_display_text(self._display_text + kchar)

		# backspace
		elif event.scancode == KEY_BACKSPACE:
			if _display_text.ends_with("]"):
				set_display_text(_display_text.left(_display_text.length()-20))
			else:
				set_display_text(_display_text.left(_display_text.length()-1))
			
			set_actual_text(_actual_text.left(_actual_text.length()-1))

		# enter
		elif event.scancode == KEY_ENTER:
			emit_signal("command_typed", id, _actual_text)
			set_text('')
		
		# update outlines
		emit_signal("typer_updated", _actual_text)


func get_text():
	return _actual_text

func set_text(_new_text):
	set_actual_text(_new_text)
	set_display_text(_new_text)

func set_actual_text(_new_text):
	_actual_text = _new_text

func set_display_text(_new_text):
	_display_text = _new_text
	
	if _caret_active:
		$Text.bbcode_text = _display_text + '_'
	else:
		$Text.bbcode_text = _display_text


func activate_selected(active):
	_active = active
	
	if active:
		$Selected.show()
	else:
		$Selected.hide()
		_caret_toggle(false)

func _capital(_kchar):
	pass
