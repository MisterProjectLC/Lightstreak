extends Node

var _cannon_list = ['Cannon1']
var _weapon_list = ['LaserTitle', 'SphereTitle', 'ShockTitle']

var _lang
var _current_phase

var player_health = 3

export var _lane_x0 = 410
export var _lane_x_increase = 100
export var _lane_y = 930



func _ready():
	# setup phase
	_current_phase = $PhaseManager.get_phase(Global.get_current_phase())
	Audio.play_music(Audio.phase_themes[Global.get_current_phase()-1])
	
	# setup language
	_lang = $LangSystem.Language.PORTUGUES
	
	# setup consoles
	$Console.set_typer_count(_current_phase[Global.Phase.CANNON_COUNT])
	$Console.set_input_specific(_current_phase[Global.Phase.INITIAL_TEXT], _current_phase[Global.Phase.CANNON_COUNT]-1)
	
	# setup cannon
	for i in range(1, _current_phase[Global.Phase.CANNON_COUNT]):
		_cannon_list.append("Cannon" + str(i+1))
		find_node(_cannon_list[i]).set_visible(true)
	
	# setup weapon lists
	for i in range(1, _current_phase[Global.Phase.POWER_COUNT]+1):
		find_node(_weapon_list[i-1]).set_visible(true)
	
	if _current_phase[Global.Phase.GENERATE]:
		for _weapon in _weapon_list:
			find_node(_weapon).set_text($LangSystem.get_word(find_node(_weapon).get_difficulty(), 
										_lang))
	
	if _current_phase[Global.Phase.REPLICATE_TEXT]:
		find_node(_weapon_list[_current_phase[Global.Phase.POWER_COUNT]-1]).set_text(_current_phase[Global.Phase.INITIAL_TEXT])
	
	# setup minion spawner
	$MinionSpawner.set_phase_script(_current_phase[Global.Phase.SCRIPT])


# tab handler
func _on_Console_tab_console(typer):
	for i in range(_cannon_list.size()):
		if i == typer:
			find_node(_cannon_list[i]).toggle_highlight(true)
		else:
			find_node(_cannon_list[i]).toggle_highlight(false)


# command handler
func _on_Console_command_typed(_typer_active, _input):
	# move
	if _input.left(5) == 'Move ' and _input.length() >= 6 and _lane(_input) != null:
		var _new_x = get_lane_x(_lane(_input))
		_move_cannon(_typer_active, _new_x)
		
	# weapon
	else:
		_weapon_handler(_typer_active, _input)


# weapon 
func _weapon_handler(_cannon_n, _input):
	for _weapon_title in _weapon_list:
		if find_node(_weapon_title).get_text() == _input:
			var _node = find_node(_weapon_title)
			# summon weapon
			var _new_weapon = _node.get_weapon().instance()
			add_child(_new_weapon)
			_change_priority(_new_weapon, 3)
			_new_weapon.position = find_node(_cannon_list[_cannon_n]).position + _new_weapon.get_weapon_offset()
			
			# replace word
			var new_word = $LangSystem.get_word(_node.get_difficulty(), _lang)
			
			# if word is a repeat, try again
			while (1):
				var repeats = false
				for i in range(_current_phase[Global.Phase.POWER_COUNT]):
					if _weapon_list[i] != _weapon_title and find_node(_weapon_list[i]).get_text() == new_word:
						new_word = $LangSystem.get_word(_node.get_difficulty(), _lang)
						repeats = true
						break
					
				if repeats == false:
					break
			
			_node.set_text(new_word)
			break


# cannon mover
func _move_cannon(_cannon_n, _new_x):
	find_node(_cannon_list[_cannon_n]).set_target_position(Vector2(_new_x, _lane_y))

# Damage / Defeat
func _on_MinionSpawner_passed_threshold():
	if player_health > 0:
		$Alerts.damage_alert()
		Audio.play_sound(Audio.player_damage, 3);
		player_health -= 1
	else:
		print("GAME OVER")

# Victory
func _on_MinionSpawner_phase_empty(time):
	if _current_phase[Global.Phase.DURATION] <= time:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")


# send back important info to the minion spawner
func _on_MinionSpawner_minion_spawned(enemy_spawner, enemy_info):
	enemy_spawner.spawn_enemy(enemy_info[Global.Spawn.MINION], get_lane_x(enemy_info[Global.Spawn.LANE]))


# bug fixers
func _lane(_input):
	if int(_input[5]) < 7:
		return _input[5].to_int()


func _change_priority(_child, _priority):
	move_child(_child, _priority)
	move_child($Battlefield, 0)
	move_child($BlackBackground, 0)


func get_lane_x(lane):
	return _lane_x0 + (_lane_x_increase * lane)
