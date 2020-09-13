extends Node

var special = {KEY_SPACE:" ", KEY_MINUS:"_"}
var menu = {KEY_PERIOD:"."}
var game = {KEY_COMMA:"<", KEY_PERIOD:">"}
var alphabet

func get_letter(input):
	if alphabet.has(input):
		return alphabet[input]
	else:
		return null

func is_special(input):
	return (input in special.values() or input in menu.values() or input in game.values())

func _ready():
	_reset()

func _reset():
	alphabet = special.duplicate()

func game_reset():
	_reset()
	for m in game.keys():
		alphabet[m] = game[m]

func menu_reset():
	_reset()
	for m in menu.keys():
		alphabet[m] = menu[m]

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
	alphabet.erase(a)
	alphabet.erase(b)
	#alphabet[a] = OS.get_scancode_string(a)
	#alphabet[b] = OS.get_scancode_string(b)
	#emit_signal('updated_alphabet', a, b, false)
