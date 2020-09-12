extends "res://Mini Scenes/Typer.gd"

func _ready():
	_active = true
	
func _capital(kchar):
	return kchar.to_upper()

func _input(event):
	input_function(event)

func set_font_size(_size):
	$Text.get("custom_fonts/normal_font").set_size(_size)
