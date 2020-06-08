extends "res://Mini Scenes/Weapon/Weapon.gd"

export(PackedScene) var shock
var _color
var _clock = 0
var _time = 0
var _shockposition = Vector2(0, 0)

var enemies_hit = []

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
		new.connect('hit_enemy', self, 'append_to_hit')
		new.append_to_hit(enemies_hit)
		
		
		_clock = 0
		
	_time += delta
	if _time > 0.4:
		delete_chain()

func append_to_hit(area):
	enemies_hit.append(area)
	for child in get_children():
		child.append_to_hit(enemies_hit)

func delete_chain():
	queue_free()
