extends Label

export var id = 0
var _actual_text = ''
var _time = 0
var _caret_blink_rate = 0.53
var _caret_active = false
var _active = false

signal command_typed

# Caret -----------------------
func _process(delta):
	if _time > _caret_blink_rate:
		_caret_blinking()
		_time = 0
	else:
		_time += delta

func _caret_toggle(_toggle):
	_caret_active = _toggle
	set_text(_actual_text)


func _caret_blinking():
	if _active == false:
		_caret_active = false
		return
	
	_caret_toggle(!_caret_active)
# ---------------------------------------


func _input(event):
	if event is InputEventKey and event.pressed and _active:
		# writable input
		if event.scancode == KEY_SPACE or (event.scancode >= KEY_A and event.scancode <= KEY_Z) or (event.scancode >= KEY_0 and event.scancode <= KEY_9):
			var kchar = OS.get_scancode_string(event.scancode)
			
			# checking alphabet
			if get_node("/root/Alphabet").get_letter(event.scancode) != null:
				kchar = get_node("/root/Alphabet").get_letter(event.scancode)

			# capitalization issues
			if has_method('_capital'):
				kchar = _capital(kchar)
			
			# append letter
			set_text(self._actual_text + kchar)
			
		# backspace
		elif event.scancode == KEY_BACKSPACE:
			set_text(_actual_text.left(_actual_text.length()-1))
			
		# enter
		elif event.scancode == KEY_ENTER:
			emit_signal("command_typed", id, _actual_text)
			set_text('')


func get_text():
	return _actual_text
	
	
func set_text(_new_text):
	_actual_text = _new_text
	
	if _caret_active:
		text = _actual_text + '_'
	else:
		text = _actual_text


func activate_selected(active):
	_active = active
	
	if active:
		$Selected.show()
	else:
		$Selected.hide()
		_caret_toggle(false)

func _capital(kchar):
	pass
