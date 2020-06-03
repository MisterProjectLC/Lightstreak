extends Node

var special = {KEY_COMMA:"<", KEY_SPACE:" ", KEY_PERIOD:">", KEY_MINUS:"_"}
var alphabet

func get_letter(input):
	if alphabet.has(input):
		return alphabet[input]
	else:
		return null

func is_special(input):
	return input in special.values()

func _ready():
	reset()

func reset():
	alphabet = special.duplicate()

func check_letter_pair(a, b):
	if a in alphabet.keys() or b in alphabet.keys():
		return true
	else:
		return false

func add_letter_pair(a, b):
	alphabet[a] = OS.get_scancode_string(b)
	alphabet[b] = OS.get_scancode_string(a)
	#emit_signal('updated_alphabet', a, b, true)
	
func remove_letter_pair(a, b):
	alphabet[a] = OS.get_scancode_string(a)
	alphabet[b] = OS.get_scancode_string(b)
	#emit_signal('updated_alphabet', a, b, false)
