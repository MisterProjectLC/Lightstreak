extends "res://Scenes/Main.gd"

var _console_count = 7
var _enemy_list

const X_OFFSET = -300

# SETUP ------------------------------------------------------
func setup_phase():
	_power_count = 8
	_cannon_count = 1
	
	_enemy_list = ["TROOPER", "TANK", "SPEEDER", "BOMBER",
					"SLICK", "HACKER", "GUARDIAN", "CAPTAIN"]

func set_title_list():
	_title_list = [get_node('TrooperTitle'), get_node('TankTitle'), 
					get_node('SpeederTitle'), get_node('BomberTitle'), 
					get_node('SlickTitle'), get_node('HackerTitle'),
					get_node('GuardianTitle'), get_node('CaptainTitle')]

func setup_cannons():
	_cannon_list.append($LaneOverlay)
	_cannon_list[0].activate()

func setup_console():
	$Console.set_typer_count(_console_count)

func setup_background():
	set_background(1)

# ---------------------------
func Console_command_typed(_typer_active, _input, _lightstreak):
	return _power_handler(0, _input, _lightstreak)


func activate_power(_index, _cannon, _lightstreak):
	spawn_enemy(_enemy_list[_index], _cannon.get_target_lane())


func spawn_enemy(enemy_minion_name, enemy_lane, _requester = null):
	$MinionSpawner.spawn_enemy(enemy_minion_name, enemy_lane, X_OFFSET)

func send_alert(message, priority):
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
	if player_health > 0:
		$Alerts.damage_alert()
		Audio.play_sound(Audio.player_damage)
		player_health -= 1
	else:
		game_over()

