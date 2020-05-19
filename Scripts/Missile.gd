extends "res://Scripts/Weapon.gd"

var _color
var _clock = 0

export(PackedScene) var blast

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
	
	# move upwards
	position.y -= 2000*delta
	if position.y < 0:
		queue_free()

func _on_Missile_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(3)
		area.set_knockback(4)
		
		var new = blast.instance()
		new.position = position
		get_parent().call_deferred("add_child", new)
		queue_free()
