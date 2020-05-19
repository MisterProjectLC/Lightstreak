extends "res://Scripts/Weapon.gd"

var _color
var _clock = 0
var _current_frame = 0
export var _animation_frames = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_weapon_offset = Vector2(0, -10)
	Audio.play_sound(Audio.sphere)

func _process(delta):
	# frames
	if _clock < 0.1:
		_clock += delta
	else:
		_clock = 0
		_current_frame += 1
		if _current_frame > _animation_frames.size()-1:
			_current_frame = 0
		
		$Sprite.texture = _animation_frames[_current_frame]
	
	# move upwards
	position.y -= 1000*delta
	if position.y < 0:
		queue_free()

func _on_Energy_Ball_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(3)
		area.set_knockback(4)
		queue_free()
