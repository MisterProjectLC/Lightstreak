extends Node2D

var _clock = 0
var _current_frame = 0
export var _animation_frames = []

var _lightstreak = false
export var _lightstreak_frames = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.play_sound(Audio.sphere)
	
	if _lightstreak:
		$Explosion/Sprite.texture = _lightstreak_frames[0]
	else:
		$Explosion/Sprite.texture = _animation_frames[0]

func _process(delta):
	# frames
	if _clock < 0.05:
		_clock += delta
	else:
		_clock = 0
		_current_frame += 1
		if _current_frame >= (_animation_frames.size()-1)/2:
			$Explosion/Collision.disabled = false
		
		if _current_frame >= _animation_frames.size()-1:
			queue_free()
		
		if _lightstreak:
			$Explosion/Sprite.texture = _lightstreak_frames[_current_frame]
		else:
			$Explosion/Sprite.texture = _animation_frames[_current_frame]


func _on_Explosion_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(3)
	
	if area.has_method("cannon_damage"):
		area.cannon_damage()
