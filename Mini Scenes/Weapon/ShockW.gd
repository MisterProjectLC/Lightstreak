extends "res://Mini Scenes/Weapon/Weapon.gd"

export(PackedScene) var shock
var _color
var _clock = 0
var _time = 0
var _shockposition = Vector2(0, 0)

func _ready():
	_weapon_offset = Vector2(0, -22)
	
	
func _process(delta):
	# create thunders
	_clock += delta
	if _clock > 0.01:
		# spawn
		var new = shock.instance()
		add_child(new)
		move_child(new, get_child_count()-1)
		
		# setup position and texture
		_shockposition += Vector2(0, -33)
		new.position = _shockposition
		new.connect('hit_enemy', self, 'delete_chain')
		
		_clock = 0
		
	_time += delta
	if _time > 0.4:
		delete_chain()

func delete_chain():
	queue_free()
