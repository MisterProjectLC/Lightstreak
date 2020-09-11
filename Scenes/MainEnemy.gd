extends "res://Scenes/Main.gd"

var _console_count = 7
var _enemy_list
var timer = 0

const X_OFFSET = -300

func _process(delta):
	timer += delta
	$Enemy_GUI.set_time(int(timer))


# SETUP ------------------------------------------------------
func setup_phase():
	_power_count = 8
	_cannon_count = 3
	
	_enemy_list = ["TROOPER", "TANK", "SPEEDER", "BOMBER",
					"SLICK", "HACKER", "GUARDIAN", "CAPTAIN"]

func set_title_list():
	_title_list = [get_node('TrooperTitle'), get_node('TankTitle'), 
					get_node('SpeederTitle'), get_node('BomberTitle'), 
					get_node('SlickTitle'), get_node('HackerTitle'),
					get_node('GuardianTitle'), get_node('CaptainTitle')]

func setup_cannons():
	for i in range(_cannon_count):
		_cannon_list.append(get_node("Cannon" + str(i+1)))
		_cannon_list[i].activate()

func setup_console():
	$Console.set_typer_count(_console_count)

func setup_background():
	set_background(1)

# ---------------------------
func Console_command_typed(_typer_active, _input, _lightstreak):
	return _power_handler(_typer_active, _input, _lightstreak)


func _power_handler(_console_n, _input, _lightstreak):
	for i in range(_power_count):
		var title = _title_list[i]
		if title.get_text() == _input:
			spawn_enemy(_enemy_list[i], _console_n, _lightstreak)
			# replace word
			return replace_word(title)
	return _input


func spawn_enemy(enemy_name, enemy_lane, _requester = null):
	Network._spawned_enemy(enemy_name, enemy_lane)
	$MinionSpawner.spawn_enemy(enemy_name, enemy_lane, X_OFFSET)

func send_alert(_message, _priority):
	pass

# GETTERS / SETTERS ---------------------------
func get_language():
	return 0

func get_lane_x(_lane):
	return Global.get_lane_x(_lane) + X_OFFSET


# SIGNALS ------------------------
func _on_Console_tab_console(_lane):
	$LaneOverlay.set_target_position( Vector2(get_lane_x(_lane), 400) )
	$LaneOverlay.set_target_lane(_lane)


func _on_MinionSpawner_passed_threshold():
	pass

