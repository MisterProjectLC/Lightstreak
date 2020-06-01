extends Node

var _cannon_list = []
var _weapon_list = []

export var _background_list = []
export(PackedScene) var heylook

var _lang
var _current_phase

var player_health = 3

signal cannon_moved
signal weapon_activated

func _ready():
	# setup phase
	_current_phase = $PhaseManager.get_phase(Global.get_current_phase())
	Audio.play_music(Audio.phase_themes[Global.get_current_phase()-1])
	_weapon_list = [get_node('LaserTitle'), get_node('SphereTitle'), 
					get_node('ShockTitle'), get_node('MagnetTitle'),
					get_node('MissileTitle'), get_node('BombTitle'), 
					get_node('MachineTitle'), get_node('DispTitle'), 
					get_node('LightTitle')]
	
	# setup language
	_lang = $LangSystem.Language.PORTUGUES
	
	# setup arena
	$Battlefield.set_background(_background_list[_current_phase[Global.Phase.ARENA]])
	
	# setup consoles
	$Console.set_typer_count(_current_phase[Global.Phase.CANNON_COUNT])
	$Console.set_input_specific(_current_phase[Global.Phase.INITIAL_TEXT], _current_phase[Global.Phase.CANNON_COUNT]-1)
	
	# setup cannon
	for i in range(0, _current_phase[Global.Phase.CANNON_COUNT]):
		_cannon_list.append(get_node("Cannon" + str(i+1)))
		_cannon_list[i].activate()
	_cannon_list[0].toggle_highlight(true)
	
	# setup weapon lists
	for i in range(1, _current_phase[Global.Phase.POWER_COUNT]+1):
		_weapon_list[i-1].set_visible(true)
	
	if _current_phase[Global.Phase.GENERATE]:
		for _weapon in _weapon_list:
			_weapon.set_text($LangSystem.get_word(_weapon.get_difficulty(), 
										_lang))
	
	# replicate text
	if _current_phase[Global.Phase.REPLICATE_TEXT] != 0:
		_weapon_list[_current_phase[Global.Phase.REPLICATE_TEXT]-1].set_text(_current_phase[Global.Phase.INITIAL_TEXT])
		typer_updated(_current_phase[Global.Phase.INITIAL_TEXT])
	
	# setup minion spawner
	$MinionSpawner.set_phase_script(_current_phase[Global.Phase.SCRIPT])
	
	# setup tutorial
	if Global.get_current_phase() == 1:
		summon_heylook()

# CONSOLE METHODS ----------------------

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		leave_game()

# tab handler
func _on_Console_tab_console(typer):
	for i in range(_cannon_list.size()):
		if i == typer:
			_cannon_list[i].toggle_highlight(true)
		else:
			_cannon_list[i].toggle_highlight(false)

# command handler
func _on_Console_command_typed(_typer_active, _input):
	# move
	if _input.left(5) == 'Move ' and _input.length() >= 6 and _lane(_input) != null:
		_move_cannon(_typer_active, _lane(_input))
		emit_signal("cannon_moved")
	
	elif _input.left(1) == '<':
		shift_cannon(_typer_active, true)

	elif _input.left(1) == '>':
		shift_cannon(_typer_active, false)

	# weapon
	else:
		_weapon_handler(_typer_active, _input)

func typer_updated(text):
	for title in _weapon_list:
		title.update_outline(text)

# weapon 
func _weapon_handler(_cannon_n, _input):
	var _cannon = _cannon_list[_cannon_n]
	
	for _weapon_title in _weapon_list:
		if _weapon_title.get_text() == _input:
			emit_signal("weapon_activated")
			var _node = _weapon_title
			# summon weapon
			var _new_weapon = _node.get_weapon().instance()
			add_child(_new_weapon)
			_change_priority(_new_weapon, 3)
			_new_weapon.position = _cannon.position + _new_weapon.get_weapon_offset()
			_new_weapon.set_weapon_lane(_cannon.get_target_lane())

			# replace word
			var new_word = $LangSystem.get_word(_node.get_difficulty(), _lang)

			# if word is a repeat, try again
			while (1):
				var repeats = false
				for i in range(_current_phase[Global.Phase.POWER_COUNT]):
					if _weapon_list[i] != _weapon_title and _weapon_list[i].get_text() == new_word:
						new_word = $LangSystem.get_word(_node.get_difficulty(), _lang)
						repeats = true
						break
					
				if repeats == false:
					break
			
			_node.set_text(new_word)
			break

# cannon mover
func _move_cannon(_cannon_n, _lane):
	var _cannon = _cannon_list[_cannon_n]
	
	_cannon.set_target_lane(_lane)
	_cannon.set_target_position(Vector2(Global.get_lane_x(_lane), Global.get_lane_y()))
	
func shift_cannon(_cannon_n, _left):
	var _cannon = _cannon_list[_cannon_n]
	var _lane = _cannon.get_target_lane()
	
	if _left:
		if _lane <= 0:
			return
		_lane -= 1
	else:
		if _lane >= 6:
			return
		_lane += 1
	
	_move_cannon(_cannon_n, _lane)

# CANNON METHODS ------------------------

func cannon_damaged(cannon, damage):
	# Yep, I'm lazy as FUCK
	
	if damage > 0:
		$Console.set_damage_typer(_cannon_list.find(get_node(cannon.name)), true)
	else:
		$Console.set_damage_typer(_cannon_list.find(get_node(cannon.name)), false)

# WIN CONDITIONS --------------------

# Damage / Defeat
func _on_MinionSpawner_passed_threshold():
	if player_health > 0:
		$Alerts.damage_alert()
		Audio.play_sound(Audio.player_damage)
		player_health -= 1
	else:
		game_over()

# Victory
func _on_MinionSpawner_phase_empty(time):
	if _current_phase[Global.Phase.DURATION] <= time:
		leave_game()

func game_over():
	leave_game()

func leave_game():
	Alphabet.reset()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

# MINION SPAWNER -----------------------------

# send back important info to the minion spawner
func _on_MinionSpawner_minion_spawned(enemy_spawner, enemy_info):
	enemy_spawner.spawn_enemy(enemy_info[Global.Spawn.MINION], enemy_info[Global.Spawn.LANE])

func send_alert(message, priority):
	$Alerts.alert(message, priority)

# HELPER FUNCTIONS ---------------------------

func summon_heylook():
	var new = heylook.instance()
	add_child(new)
	move_child(new, get_child_count()-1)
	new.rect_position.x = 9
	new.rect_position.y = 607
	connect('cannon_moved', new, 'start')
	connect('weapon_activated', new, 'destroy')

# bug fixers
func _lane(_input):
	if int(_input[5]) < 7:
		return _input[5].to_int()


func _change_priority(_child, _priority):
	move_child(_child, _priority)
	move_child($Battlefield, 0)
	move_child($BlackBackground, 0)


