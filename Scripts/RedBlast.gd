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
	if _fading:
		if $RedBlast/Sprite.get_modulate().a <= 0.1:
			if _warned  == true:
				emit_signal('send_alert', (">>>" + str(_lane) + "<<<"), 0)
				queue_free()
			else:
				_fading = false
		$RedBlast/Sprite.set_modulate($RedBlast/Sprite.get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
	
	else:
		if $RedBlast/Sprite.get_modulate().a >= 0.5:
			if _warned  == false or $RedBlast/Sprite.get_modulate().a >= 1:
				_fading = true
	
		if _warned == false:
			$RedBlast/Sprite.set_modulate($RedBlast/Sprite.get_modulate() + Color(0, 0, 0, 5*delta*_fading_speed))
		else:
			$RedBlast/Sprite.set_modulate($RedBlast/Sprite.get_modulate() + Color(0, 0, 0, 15*delta*_fading_speed))
	
	if _warning > 0:
		_warning -= delta
		return
	
	if _warned == false:
		_warned = true
		Audio.play_sound(Audio.red_arena)
		$RedBlast/Collision.disabled = false
		$RedBlast/Sprite.set_modulate(Color($RedBlast/Sprite.get_modulate().r, $RedBlast/Sprite.get_modulate().g, 
										$RedBlast/Sprite.get_modulate().b, 0))
		_fading = false


func set_lane(_lane):
	self._lane = _lane
