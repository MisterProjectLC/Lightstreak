extends Node2D

var _warning = 3
var _warned = false

var _fading = false
var _fading_speed = 2

var _lane = 1

signal send_alert

func ready():
	position.y = Global.get_lane_y()/2
	emit_signal('send_alert', (">>>" + str(_lane) + "<<<"), 3)

func _on_RedBlast_area_entered(area):
	if area.has_method("cannon_damage"):
		area.cannon_damage()
	
	if area.has_method("take_damage"):
		area.take_damage(5)

func _process(delta):
	if _warning > 0:
		_warning -= delta
		return
	
	if _warned == false:
		_warned = true
		Audio.play_sound(Audio.laser, 2)
		$RedBlast/Collision.disabled = false
	
	if _fading:
		$RedBlast/Sprite.set_modulate($RedBlast/Sprite.get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
		if $RedBlast/Sprite.get_modulate().a <= 0.1:
			emit_signal('send_alert', (">>>" + str(_lane) + "<<<"), 0)
			queue_free()
	else:
		$RedBlast/Sprite.set_modulate($RedBlast/Sprite.get_modulate() + Color(0, 0, 0, delta*15*_fading_speed))
		if $RedBlast/Sprite.get_modulate().a >= 1:
			_fading = true
			#$RedBlast/Collision.disabled = true


func set_lane(_lane):
	self._lane = _lane
