extends "res://Scripts/Weapon.gd"

var _color
var _clock = 0

export(PackedScene) var blast

# Called when the node enters the scene tree for the first time.
func _ready():
	_weapon_offset = Vector2(0, -10)
	#Audio.play_sound(Audio.sphere, 1)

func _process(delta):
	# frames
	if _clock < 0.1:
		_clock += delta
	else:
		_clock = 0
	
	# move upwards
	#position.y -= 750*delta
	var deltar = 9*delta
	position.y = position.y *(1- deltar) + 470 * deltar
	if position.y < 480:
		_explode()
		

func _explode():
	var new = blast.instance()
	new.position = position
	new.set_modulate(Color(0, 1, 0.78, 1))
	new.scale *= 1.37
	get_parent().add_child(new)
	queue_free()
