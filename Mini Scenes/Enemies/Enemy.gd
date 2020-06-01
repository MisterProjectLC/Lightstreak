extends Area2D

signal pass_threshold
signal changed_stunned
signal send_alert

var _lane = 1

var _health
export(int) var _max_health
export(int) var _speed
var _knockback = 0
var _knockside = 0
var _stunned = 0
var _protected = false
var _clock = 0

export(Texture) var damaged_sprite

func _ready():
	set_health(_max_health)

func _process(delta):
	pass

func process(delta):
	# Knockback
	if _knockback > 0:
		position.y -= _knockback*25*delta
		_knockback -= 4*delta
	
	# Knockside
	_manage_knockside(delta)
	
	# Movement
	if _stunned <= 0:
		$Paralysis.frame = 0
		position.y += _speed*25*delta
	
		if position.y > 850:
			print("pass")
			emit_signal("pass_threshold")
			destroy()
	else:
		_stunned -= delta
		_clock += delta
		if _clock > 0.1:
			$Paralysis.frame += 1
			if $Paralysis.frame >= 6:
				$Paralysis.frame = 1
		
		if _stunned <= 0:
			emit_signal('changed_stunned', 0)

func _manage_knockside(delta):
	# Knockside
	if abs(_knockside) > 2:
		var speed = 200*delta*(abs(_knockside)/_knockside)
		position.x += speed
		_knockside -= speed

func set_lane(_lane):
	self._lane = _lane

func get_lane():
	return _lane

func set_health(_new):
	_health = _new

func get_health():
	return _health
	
func set_max_health(_new):
	_max_health = _new

func get_max_health():
	return _max_health
	
func set_speed(_new):
	_speed = _new

func get_speed():
	return _speed
	
func set_stunned(_new):
	_stunned = _new
	emit_signal('changed_stunned', _new)
	
func set_knockback(_new):
	_knockback = _new

func set_knockside(_new):
	_knockside = _new*Global.get_lane_x_increase()
	set_lane(_lane+_new)

func take_damage(_damage):
	if _protected:
		return
	
	_health -= _damage
	
	if damaged_sprite:
		$Sprite.texture = damaged_sprite
	if _health <= 0:
		destroy()

func set_protected(_new):
	_protected = _new

func destroy():
	queue_free()