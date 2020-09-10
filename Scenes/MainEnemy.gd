extends "res://Scenes/Main.gd"

var current_lane = 0

func ready():
	_weapon_list = [get_node('TrooperTitle'), get_node('TankTitle'), 
					get_node('SpeederTitle'), get_node('HackerTitle'),
					get_node('BomberTitle'), get_node('SlickTitle'), 
					get_node('GuardianTitle'), get_node('CaptainTitle')]
					
	_cannon_list.append($LaneOverlay)
	$ConsoleEnemy.set_typer_count(7)


func _on_Console_tab_console(_lane):
	_cannon_list[0].set_target_position(Vector2(Global.get_lane_x(_lane), Global.get_lane_y()))
	current_lane = _lane


func Console_command_typed(_typer_active, _input, _lightstreak):
	# spawn enemy
	return _weapon_handler(_typer_active, _input, _lightstreak)


func activate_power(_node, _cannon, _lightstreak):
	# summon weapon
	var _new_enemy = _node.get_weapon().instance()
	add_child(_new_enemy)
	_change_priority(_new_enemy, 3)
	
	_new_enemy.position = Vector2(_cannon.position.x, 0)
	_new_enemy.set_lane(_cannon.get_target_lane())
