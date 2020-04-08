extends "res://Scripts//Weapon.gd"

var _fading = false
var _color
var _fading_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	_weapon_offset = Vector2(0, -462)
	Audio.play_sound(Audio.laser, 1)

func _process(delta):
	if _fading:
		$Sprite.set_modulate($Sprite.get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
		if $Sprite.get_modulate().a <= 0.1:
			queue_free()
	else:
		$Sprite.set_modulate($Sprite.get_modulate() + Color(0, 0, 0, delta*15*_fading_speed))
		if $Sprite.get_modulate().a >= 1:
			_fading = true

func set_fading(_new):
	_fading = _new

func _on_Laser_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(2)
