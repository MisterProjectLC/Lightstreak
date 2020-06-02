extends Node

export(PackedScene) var trooper
export(PackedScene) var tank
export(PackedScene) var speeder
export(PackedScene) var hacker
export(PackedScene) var hacker_init
export(PackedScene) var red_blast
export(PackedScene) var bomber
export(PackedScene) var slick
export(PackedScene) var violet_blast
export(PackedScene) var guardian
var enemy_object = {}

var _clock = 0
var _time = 0
var _last_spawned = 0
export(int) var _spawn_y = 0

var _phase_script = []

signal phase_empty
signal minion_spawned
signal passed_threshold
signal send_alert

var blasts = 0

func _ready():
	enemy_object = {"TROOPER":trooper, "TANK":tank, "SPEEDER":speeder, 
	"HACKER":hacker, "HACKERI":hacker_init, "REDBLAST":red_blast,
	"BOMBER":bomber, "SLICK":slick, "VIOLETBLAST":violet_blast,
	"GUARDIAN":guardian}


func _process(delta):
	# time
	if _clock < 1:
		_clock += delta
	else:
		_clock = 0
		_time += 1
		
		# spawn enemy
		while true:
			if _last_spawned < _phase_script.size() and _phase_script[_last_spawned]["TIME"] == _time:
				emit_signal("minion_spawned", self, _phase_script[_last_spawned])
				_last_spawned += 1
			else:
				break
				
		# signal when there are no enemies around
		if get_child_count() - blasts <= 0:
			emit_signal("phase_empty", _time)


func spawn_enemy(enemy_type, lane):
	# spawn and setup enemy
	var _new = enemy_object[enemy_type].instance()
	add_child(_new)
	move_child(_new, get_child_count()-1)
	
	if _new.has_method("i_am_vblast"):
		blasts += 1
	
	_new.connect('send_alert', self, 'send_alerts')
	_new.set_lane(lane)

	_new.set_position(Vector2(Global.get_lane_x(lane), _spawn_y))
	
	for i in _new.get_signal_list().size():
		if _new.get_signal_list()[i]["name"] == "pass_threshold":
			_new.connect('pass_threshold', self, 'passed_threshold')
			break
	
	if _new.has_method("ready"):
		_new.ready()


func passed_threshold():
	emit_signal("passed_threshold")

func set_phase_script(_phase_script):
	self._phase_script = _phase_script

func send_alerts(message, priority):
	emit_signal("send_alert", message, priority)
