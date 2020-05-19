extends "res://Scripts/Enemy.gd"

export(PackedScene) var explosion

func _process(delta):
	process(delta)

func destroy():
	Audio.play_sound(Audio.bomber)
	var new = explosion.instance()
	new.position = position
	get_parent().add_child(new)
	
	.destroy()
