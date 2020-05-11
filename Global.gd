extends Node

enum Spawn{TIME, MINION, LANE}
enum Phase{GENERATE, DURATION, CANNON_COUNT, POWER_COUNT, INITIAL_TEXT, REPLICATE_TEXT, ARENA, SCRIPT}
enum Minion{TROOPER, TANK, SPEEDER, HACKER, HACKERI}
enum Arena{BLUE, RED, PURPLE}

var language = 0
var music_volume = 0.7
var sounds_volume = 1
var current_phase = 1
var lightstreak_typed = false

var _lane_x0 = 340
var _lane_x_increase = 71
var _lane_y = 740

var debug_enabled = false

func get_lightstreak_typed():
	return lightstreak_typed

func set_lightstreak_typed(_new):
	lightstreak_typed = _new

func get_language():
	return language

func set_language(_new):
	language = _new
	
func get_music_volume():
	return music_volume

func set_music_volume(_new: float):
	_new = _new/100 + 0.001
	music_volume = _new
	print(_new)
	Audio.volume_db = linear2db(_new)

func get_sounds_volume():
	return sounds_volume

func set_sounds_volume(_new: float):
	_new = _new/100 + 0.001
	sounds_volume = _new
	print(_new)

func get_current_phase():
	return current_phase

func set_current_phase(_new):
	current_phase = _new

func get_debug_enabled():
	return debug_enabled
	
func set_debug_enabled(_new):
	debug_enabled = _new

func get_lane_x():
	return _lane_x0

func get_lane_y():
	return _lane_y

func get_lane_increase():
	return _lane_x_increase
