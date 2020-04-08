extends "Typer.gd"

export(Texture) var sprite

func _ready():
	$Outline.texture = sprite
	
func _capital(kchar):
	if _actual_text.length() == 0:
		return kchar.to_upper()
	else:
		return kchar.to_lower()
