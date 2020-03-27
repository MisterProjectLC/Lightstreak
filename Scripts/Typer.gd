extends Label

export(Texture) var sprite

var _actual_text = ''
var _time = 0
var _caret_blink_rate = 0.53
var _caret_active = false
var _active = false

func _ready():
	$Outline.texture = sprite
	
	
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
