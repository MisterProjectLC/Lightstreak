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
export(PackedScene) var captain
export(PackedScene) var boss
var enemy_object = {}

var _clock = 0
var _time = 0
var _last_spawned = 0
export(int) var _spawn_y = 0

var phase_script = []

signal phase_empty
signal passed_threshold
signal send_alert

var blasts = []

func _ready():
	enemy_object = {"TROOPER":trooper, "TANK":tank, "SPEEDER":speeder, 
	"HACKER":hacker, "HACKERI":hacker_init, "REDBLAST":red_blast,
	"BOMBER":bomber, "SLICK":slick, "VIOLETBLAST":violet_blast,
	"GUARDIAN":guardian, "CAPTAIN":captain, "BOSS":boss}


func _process(delta):
	if phase_script != []:
		read_phase_script(delta)


func read_phase_script(delta):
	# time
	if _clock < 1:
		_clock += delta
	else:
		_clock = 0
		_time += 1
		
		# spawn enemy
		while true:
			if _last_spawned < phase_script.size() and phase_script[_last_spawned]["TIME"] == _time:
				spawn_enemy(phase_script[_last_spawned]["MINION"], phase_script[_last_spawned]["LANE"])
				_last_spawned += 1
			else:
				break
				
		# signal when there are no enemies around
		if get_child_count() - len(blasts) <= 0:
			emit_signal("phase_empty", _time)


func spawn_enemy(enemy_type, lane, x_offset = 0):
	# spawn and setup enemy
	var _new = enemy_object[enemy_type].instance()
	add_child(_new)
	move_child(_new, get_child_count()-1)
	
	if _new.has_method("i_am_vblast"):
		add_blasts(_new)
	else:
		_new.connect('send_alert', self, 'send_alerts')
	
	# seta lane e position
	_new.set_lane(lane)
	_new.set_position(Vector2(Global.get_lane_x(lane) + x_offset, _spawn_y))
	
	# prepara signal de pass_threshold
	for i in _new.get_signal_list().size():
		if _new.get_signal_list()[i]["name"] == "pass_threshold":
			_new.connect('pass_threshold', self, 'passed_threshold')
			break
	
	# inicia enemy
	if _new.has_method("ready"):
		_new.ready()
	
	return _new


func add_blasts(_new):
	blasts.append(_new)


func clear_blasts():
	for blast in blasts:
		blast.queue_free()
	blasts.clear()


func set_phase_script(_phase_script):
	self.phase_script = _phase_script

func passed_threshold():
	emit_signal("passed_threshold")

func send_alerts(message, priority):
	emit_signal("send_alert", message, priority)
