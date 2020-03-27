extends Node

export(PackedScene) var trooper
export(PackedScene) var tank
export(PackedScene) var speeder
export(PackedScene) var hacker
export(PackedScene) var hacker_init
var enemy_object = {}

var _clock = 0
var _time = 0
var _last_spawned = 0
export(int) var _spawn_y = 0

var _phase_script = []

signal minion_spawned
signal passed_threshold

func _ready():
	var Minion = Enums.Minion
	enemy_object = {Minion.TROOPER:trooper, Minion.TANK:tank, Minion.SPEEDER:speeder, 
	Minion.HACKER:hacker, Minion.HACKERI:hacker_init}


func _process(delta):
	# time
	if _clock < 1:
		_clock += delta
	else:
		_clock = 0
		_time += 1
		
		# spawn enemy
		while true:
			if _last_spawned < _phase_script.size() and _phase_script[_last_spawned][Enums.Spawn.TIME] == _time:
				emit_signal("minion_spawned", self, _phase_script[_last_spawned])
				_last_spawned += 1
			else:
				break


func spawn_enemy(enemy_type, new_x):
	# spawn and setup enemy
	var _new = enemy_object[enemy_type].instance()
	add_child(_new)
	move_child(_new, get_child_count()-1)
	
	_new.set_position(Vector2(new_x, _spawn_y))
	_new.connect('pass_threshold', self, 'passed_threshold')


func passed_threshold():
	emit_signal("passed_threshold")
	
func set_phase_script(_phase_script):
	self._phase_script = _phase_script
	
