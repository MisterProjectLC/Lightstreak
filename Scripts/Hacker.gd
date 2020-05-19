extends "res://Scripts/Enemy.gd"

var a = KEY_M
var b = KEY_V
export var initial = false

signal hack

func _ready():
	._ready()

func ready():
	if !initial:
		a = generate_char()
		b = generate_char()
	
		while a == b || Alphabet.check_letter_pair(a, b):
			a = generate_char()
			b = generate_char()
	
	#emit_signal('hack')
	change_display_letters()
	change_alphabet_letters()

func _process(delta):
	process(delta)

func generate_char():
	var dict = [KEY_B, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J,
		KEY_K, KEY_L, KEY_M, KEY_N, KEY_P, KEY_Q, KEY_R, KEY_S, 
		KEY_T, KEY_V]
	var rand = randi() % dict.size()

	return dict[rand]

func change_display_letters():
	$Label.text = OS.get_scancode_string(a)
	$Label2.text = OS.get_scancode_string(b)
	pass
	
func change_alphabet_letters():
	activate_hack()

func destroy():
	disable_hack()
	.destroy()


func _on_Hacker_changed_stunned(_new):
	if _new > 0:
		disable_hack()
	else:
		activate_hack()


func activate_hack():
	get_node("/root/Alphabet").add_letter_pair(a, b)
	emit_signal('send_alert', (OS.get_scancode_string(a) + ' <-> ' + OS.get_scancode_string(b)), 2)
	
func disable_hack():
	get_node("/root/Alphabet").remove_letter_pair(a, b)
	emit_signal('send_alert', (OS.get_scancode_string(a) + ' <-> ' + OS.get_scancode_string(b)), 0)
