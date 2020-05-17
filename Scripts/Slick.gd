extends "res://Scripts/Enemy.gd"


var _timer = 0

func _process(delta):
	if _timer > 0:
		_timer -= delta
	else:
		_timer = 2
		
		var knocksider = randi() % 7
		knocksider -= get_lane()
		
		set_knockside(knocksider)

	._process(delta)

func _manage_knockside(delta):
		# Knockside
	if abs(_knockside) > 2:
		var speed = 200*delta*(abs(_knockside)/_knockside)
		position.x += speed
		_knockside -= speed
		
		# 90 graus - lane increase
		rotation_degrees += speed*90/Global.get_lane_x_increase()
	

