extends Node

var alphabet = {KEY_SPACE:" "}
signal updated_alphabet

func get_letter(input):
	if alphabet.has(input):
		return alphabet[input]
	else:
		return null
		
func add_letter_pair(a, b):
	alphabet[a] = OS.get_scancode_string(b)
	alphabet[b] = OS.get_scancode_string(a)
	emit_signal('updated_alphabet', a, b, true)
	
func remove_letter_pair(a, b):
	alphabet[a] = OS.get_scancode_string(a)
	alphabet[b] = OS.get_scancode_string(b)
	emit_signal('updated_alphabet', a, b, false)
