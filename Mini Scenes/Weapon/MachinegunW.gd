extends "res://Mini Scenes/Weapon/Weapon.gd"

export(PackedScene) var bullet
var _clock = 0
var _bullets_fired = 0

func _ready():
	_weapon_offset = Vector2(0, -35)

func _process(delta):
	_clock += delta
	if _clock > 0.2:
		_clock = 0
		
		var _new = bullet.instance()
		get_parent().add_child(_new)
		_new.position = position
		_new._lightstreak = _lightstreak
		
		_bullets_fired += 1
		if _bullets_fired >= 4:
			queue_free()

