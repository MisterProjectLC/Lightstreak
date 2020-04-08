extends Area2D

signal pass_threshold
signal changed_stunned

var _health
export(int) var _max_health
export(int) var _speed
var _knockback = 0
var _stunned = 0
var _clock = 0

func _ready():
	set_health(_max_health)

func _process(delta):
	# Knockback
	if _knockback > 0:
		position.y -= _knockback*25*delta
		_knockback -= 4*delta
	
	# Movement
	if _stunned <= 0:
		$Paralysis.frame = 0
		position.y += _speed*25*delta
	
		if position.y > 850:
			emit_signal("pass_threshold")
			destroy()
	else:
		_stunned -= delta
		_clock += delta
		if _clock > 0.1:
			$Paralysis.frame += 1
		
		if _stunned <= 0:
			emit_signal('changed_stunned', 0)
		

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

func take_damage(_damage):
	_health -= _damage
	if _health <= 0:
		destroy()

func destroy():
	queue_free()
