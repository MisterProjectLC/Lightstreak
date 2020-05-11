extends "res://Scripts/Enemy.gd"

signal hack
var a = KEY_M
var b = KEY_V
export var initial = false

func _ready():
	._ready()
	
	if !initial:
		a = generate_char()
		b = generate_char()
	
		while a == b:
			b = generate_char()
	
	
	emit_signal('hack')
	
func _process(delta):
	pass

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
	get_node("/root/Alphabet").add_letter_pair(a, b)
	
func destroy():
	get_node("/root/Alphabet").remove_letter_pair(a, b)
	.destroy()


func _on_Hacker_changed_stunned(_new):
	if _new > 0:
		get_node("/root/Alphabet").remove_letter_pair(a, b)
	else:
		get_node("/root/Alphabet").add_letter_pair(a, b)
