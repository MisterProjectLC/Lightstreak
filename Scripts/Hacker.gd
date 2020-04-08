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
	var rand = randi() % 26
	var dict = {1:KEY_A, 2:KEY_B, 3:KEY_C, 4:KEY_D, 5:KEY_E, 6:KEY_F, 7:KEY_G, 8:KEY_H, 9:KEY_I, 10:KEY_J,
		11:KEY_K, 12:KEY_L, 13:KEY_M, 14:KEY_N, 15:KEY_O, 16:KEY_P, 17:KEY_Q, 18:KEY_R, 19:KEY_S, 20:KEY_T,
		21:KEY_U, 22:KEY_V, 23:KEY_W, 24:KEY_X, 25:KEY_Y, 0:KEY_Z}
				
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
