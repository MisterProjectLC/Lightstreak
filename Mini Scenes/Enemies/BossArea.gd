extends Area2D


export(String, "mid","blue", "red", "violet") var color

signal damaged

func set_lane(_lane):
	get_parent().set_lane(_lane)

func get_lane():
	return get_parent().lane

func set_speed(_new):
	get_parent().set_speed(_new)

func get_speed():
	return get_parent()._speed
	
func set_stunned(_new):
	get_parent().set_stunned(_new)
	
func set_knockback(_new):
	get_parent().set_knockback(_new)

func set_knockside(_new):
	get_parent().set_knockside(_new)

func take_damage(_damage):
	emit_signal("damaged")
	get_parent().take_damage(_damage)

func set_protected(_new):
	get_parent().set_protected(_new)

func destroy():
	get_parent().destroy()
