extends "res://Scripts/Enemy.gd"

export(PackedScene) var explosion

func destroy():
	var new = explosion.instance()
	new.position = position
	get_parent().add_child(new)
	
	.destroy()
