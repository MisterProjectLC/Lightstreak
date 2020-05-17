extends "res://Scripts/Enemy.gd"

export(PackedScene) var explosion

func destroy():
	Audio.play_sound(Audio.bomber, 4)
	var new = explosion.instance()
	new.position = position
	get_parent().add_child(new)
	
	.destroy()
