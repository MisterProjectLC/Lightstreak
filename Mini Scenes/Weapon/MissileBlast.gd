extends "res://Mini Scenes/Weapon/Weapon.gd"

var _fading = false
var _color
var _fading_speed = 12

var distance_to_go = 800
var distance_speed = 1600

# Called when the node enters the scene tree for the first time.
func _ready():
	_weapon_offset = Vector2(0, -462)
	Audio.play_sound(Audio.missile_blast)

func _process(delta):
	if distance_to_go > 0:
		var delta_mov = distance_speed*delta
		$Left.position.x -= delta_mov
		$Right.position.x += delta_mov
		$Mid.scale.x += distance_speed*delta/30
		distance_to_go -= delta_mov
		return
	
	if _fading:
		set_modulate(get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
		if get_modulate().a <= 0.1:
			queue_free()
	else:
		set_modulate(get_modulate() + Color(0, 0, 0, delta*15*_fading_speed))
		if get_modulate().a >= 1:
			_fading = true

func set_fading(_new):
	_fading = _new

func _on_MissileBlast_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(3)
