extends "res://Mini Scenes/Weapon/Projectile.gd"

var _color
var _clock = 0

export(PackedScene) var blast

func _ready():
	Audio.play_sound(Audio.sphere)
	ready()
	if _lightstreak:
		$Sprite.texture = _lightstreak_sprite

func _process(delta):
	# frames
	if _clock < 0.1:
		_clock += delta
	else:
		_clock = 0

func _on_Missile_area_entered(area):
	if area.has_method("take_damage"):
		var new = blast.instance()
		new.position = position
		new._lightstreak = _lightstreak
		get_parent().call_deferred("add_child", new)
	
	damage(area)
