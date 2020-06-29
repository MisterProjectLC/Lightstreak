extends "res://Mini Scenes/Enemies/Enemy.gd"

var _timer = 8
var _main
var violetblast = null
var color = 0

func set_main(_new):
	_main = _new

func _process(delta):
	if !_stunned:
		if _timer > 0:
			_timer -= delta
		else:
			_timer = 3
			
			var knocksider = 1 + (randi() % 5)
			knocksider -= get_lane()
			
			set_knockside(knocksider)

	__process(delta)

func _set_lane(_lane):
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
		
		# 120 graus - lane increase
		rotation_degrees += speed*120/Global.get_lane_x_increase()


func _on_AreaBlue_damaged():
	if color == 0:
		return
	
	color = 0
	_main.set_background(color)
	if is_instance_valid(violetblast):
		violetblast.destroy()

func _on_AreaRed_damaged():
	if color == 1:
		return
	
	color = 1
	_main.spawn_enemy("REDBLAST", 4 + (randi() % 3))
	_main.spawn_enemy("REDBLAST", randi() % 4)
	_main.set_background(color)
	if is_instance_valid(violetblast):
		violetblast.destroy()


func _on_AreaViolet_damaged():
	if color == 2:
		return
	
	color = 2
	violetblast = _main.spawn_enemy("VIOLETBLAST", 3)
	_main.set_background(color)
