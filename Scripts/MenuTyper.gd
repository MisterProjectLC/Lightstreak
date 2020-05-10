extends "Typer.gd"

func _ready():
	_active = true
	
func _capital(kchar):
	return kchar.to_upper()
