extends "res://Mini Scenes/Typer.gd"

export(Texture) var sprite

var damaged = false

func _ready():
	$Outline.texture = sprite
	
func _capital(kchar):
	if _actual_text.length() == 0:
		return kchar.to_upper()
	else:
		return kchar.to_lower()

func _input(event):
	if !damaged:
		input_function(event)

func set_damage(damaged):
	self.damaged = damaged
	
	if damaged:
		$Outline.set_modulate(Color(1, 0, 0, 1))
	else:
		$Outline.set_modulate(Color(1, 1, 1, 1))
