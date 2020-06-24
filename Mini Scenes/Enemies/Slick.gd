extends "res://Mini Scenes/Enemies/Enemy.gd"

var _timer = 2

func _process(delta):
	if !_stunned:
		if _timer > 0:
			_timer -= delta
		else:
			_timer = 3
			
			var knocksider = randi() % 7
			knocksider -= get_lane()
			
			set_knockside(knocksider)

	process(delta)

func set_lane(_lane):
	self.lane = _lane

func set_knockside(_new):
	_knockside = _new*Global.get_lane_x_increase()
	
	var _actual_lane = (position.x - Global.get_lane_x_start())/Global.get_lane_x_increase()
	set_lane(int(_actual_lane)+_new)

func _manage_knockside(delta):
		# Knockside
	if abs(_knockside) > 2:
		var speed = 200*delta*(abs(_knockside)/_knockside)
		position.x += speed
		_knockside -= speed
		
		# 90 graus - lane increase
		rotation_degrees += speed*90/Global.get_lane_x_increase()
	

