extends "res://Scripts/Projectile.gd"

var _color
var _clock = 0
var _current_frame = 0
export var _animation_frames = []

func _ready():
	Audio.play_sound(Audio.sphere)
	ready()

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


func _on_Energy_Ball_area_entered(area):
	damage(area)
