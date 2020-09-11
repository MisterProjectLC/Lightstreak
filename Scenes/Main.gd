extends Node

var _cannon_list = []
var _title_list = []
var _weapon_list = []

export var _background_list = []
export(PackedScene) var heylook

var _current_phase
var _cannon_count
var _power_count

var player_health = 3

signal cannon_moved
signal weapon_activated


# SETUP ------------------------------------------------------------

func _ready():
	ready()

func ready():
	# setup phase
	setup_phase()
	Audio.play_music(Audio.phase_themes[Global.get_current_phase()-1])
	
	# setup weapons
	_weapon_list = [load("res://Mini Scenes/Weapon/Laser.tscn"),
	load("res://Mini Scenes/Weapon/EnergyBall.tscn"),
	load("res://Mini Scenes/Weapon/ShockW.tscn"),
	load("res://Mini Scenes/Weapon/Magnet.tscn"),
	load("res://Mini Scenes/Weapon/Missile.tscn"),
	load("res://Mini Scenes/Weapon/Bomb.tscn"),
	load("res://Mini Scenes/Weapon/MachinegunW.tscn"),
	load("res://Mini Scenes/Weapon/Push.tscn"),
	load("res://Mini Scenes/Weapon/Laser.tscn"),]
	
	# setup titles
	set_title_list()
	setup_title_list()
	setup_title_replicate()
	
	# other setup
	setup_background()
	setup_cannons()
	setup_console()
	
	# setup tutorial
	if Global.get_current_phase() == 1:
		summon_heylook()


func setup_phase():
	$PhaseManager.load_phase(Global.get_current_phase())
	_current_phase = $PhaseManager.get_phase()
	_power_count = _current_phase["POWER_COUNT"]
	_cannon_count = _current_phase["CANNON_COUNT"]
	$MinionSpawner.set_phase_script(_current_phase["SCRIPT"])

func set_title_list():
	_title_list = [get_node('LaserTitle'), get_node('SphereTitle'), 
					get_node('ShockTitle'), get_node('MagnetTitle'),
					get_node('MissileTitle'), get_node('BombTitle'), 
					get_node('MachineTitle'), get_node('PushTitle'), 
					get_node('LightTitle')]

func setup_title_list():
	for i in range(1, _power_count+1):
		_title_list[i-1].set_visible(true)
	
	for w in range(len(_title_list)):
		var new_word = $LangSystem.get_word(_title_list[w].get_difficulty(), 
										get_language())
		# if word is a repeat, try again
		while (1):
			var repeats = false
			for i in range(_power_count):
				if _title_list[i] != _title_list[w] and _title_list[i].get_text() == new_word:
					new_word = $LangSystem.get_word(_title_list[i].get_difficulty(), get_language())
					repeats = true
					break
				
			if repeats == false:
				break
			
		_title_list[w].set_text(new_word)

func setup_title_replicate():
	pass

func setup_background():
	pass

func setup_cannons():
	for i in range(_cannon_count):
		_cannon_list.append(get_node("Cannon" + str(i+1)))
		_cannon_list[i].activate()
	_cannon_list[0].toggle_highlight(true)

func setup_console():
	$Console.set_typer_count(_cannon_count)

# CONSOLE METHODS ----------------------

# tab handler
func _on_Console_tab_console(typer):
	for i in range(_cannon_list.size()):
		if i == typer:
			_cannon_list[i].toggle_highlight(true)
		else:
			_cannon_list[i].toggle_highlight(false)


# command handler
func _on_Console_command_typed(_typer_active, _input):
	Console_command_typed(_typer_active, _input, false)


func Console_command_typed(_typer_active, _input, _lightstreak):
	# move
	if _input.left(5) == 'Move ' and _input.length() >= 6 and _lane(_input) != null:
		_move_cannon(_typer_active, _lane(_input))
		emit_signal("cannon_moved")
	
	elif _input.left(1) == '<':
		shift_cannon(_typer_active, true)

	elif _input.left(1) == '>':
		shift_cannon(_typer_active, false)

	# lightstreak
	elif (_input.left(6) == 'Light ' and len(_input) >= 6) or (_input.left(7) == 'Streak ' and len(_input) >= 7):
		_lightstreak_handler(_input)

	# weapon
	else:
		return _power_handler(_typer_active, _input, _lightstreak)
	
	return _input


func _on_Console_typer_updated(text):
	typer_updated(text)

func typer_updated(text):
	for title in _title_list:
		title.update_outline(text)
		if text.left(6) == 'Light ' and title.get_text() != "Light":
			title.update_outline(text.lstrip("Light "))
		elif text.left(7) == 'Streak ' and title.get_text() != "Streak":
			title.update_outline(text.lstrip("Streak "))


func _lightstreak_handler(_input):
	var final_input
	if _title_list[-1].get_text() == "Light": 
		final_input = _input.right(6)
	elif _title_list[-1].get_text() == "Streak":
		final_input = _input.right(7)
	else:
		return ""
	
	# replace word
	var new_word = ["Light", "Streak"][randi() % 2]
	_title_list[-1].set_text(new_word)
	
	print("Lightstreak activated: " + final_input)
	for i in range(len(_cannon_list)):
		var helper = Console_command_typed(i, final_input, true)
		final_input = helper


# weapon 
func _power_handler(_console_n, _input, _lightstreak):
	var _cannon = _cannon_list[_console_n]
	
	for i in range(_power_count):
		var title = _title_list[i]
		
		if title.get_text() == _input:
			emit_signal("weapon_activated")
			# summon power
			activate_power(i, _cannon, _lightstreak)
			
			# replace word
			var new_word = $LangSystem.get_word(title.get_difficulty(), get_language())
			
			# if word is a repeat, try again
			while (1):
				var repeats = false
				for j in range(_power_count):
					if _title_list[j] != title and _title_list[j].get_text() == new_word:
						new_word = $LangSystem.get_word(title.get_difficulty(), get_language())
						repeats = true
						break
				
				if repeats == false:
					break
			
			title.set_text(new_word)
			return new_word
			
	return _input


func activate_power(_index, _cannon, _lightstreak):
	summon_weapon(_weapon_list[_index], _cannon, _lightstreak)


func summon_weapon(_node, _cannon, _lightstreak):
	# summon weapon
	var _new_weapon = _node.instance()
	add_child(_new_weapon)
	_change_priority(_new_weapon, 3)
	_new_weapon.position = _cannon.position + _new_weapon.get_weapon_offset()
	_new_weapon.set_weapon_lane(_cannon.get_target_lane())
	_new_weapon.set_lightstreak(_lightstreak)


# cannon mover
func _move_cannon(_cannon_n, _lane):
	var _cannon = _cannon_list[_cannon_n]
	
	_cannon.set_target_lane(_lane)
	_cannon.set_target_position(Vector2(get_lane_x(_lane), Global.get_lane_y()))


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
	if _current_phase["DURATION"] == 10:
		credits()
	elif _current_phase["DURATION"] <= time:
		leave_game()


func game_over():
	print_debug("game_over")
	leave_game()


func credits():
	$AnimationPlayer.play("Fade")


func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().change_scene("res://Scenes/Credits.tscn")


func leave_game():
	Alphabet.reset()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

# MINION SPAWNER -----------------------------

func spawn_enemy(enemy_minion_name, enemy_lane, _requester = null):
	$MinionSpawner.spawn_enemy(enemy_minion_name, enemy_lane)

func send_alert(message, priority):
	$Alerts.alert(message, priority)

# HELPER FUNCTIONS ---------------------------

func get_language():
	return Global.get_language()

func get_lane_x(_lane):
	Global.get_lane_x(_lane)

func set_background(_new_arena):
	$Battlefield.set_background(_background_list[_new_arena])
	
	if _new_arena != 2:
		$MinionSpawner.clear_blasts()

func summon_heylook():
	pass

# bug fixers
func _lane(_input):
	if int(_input[5]) < 7:
		return _input[5].to_int()


func _change_priority(_child, _priority):
	move_child(_child, _priority)
	move_child($Battlefield, 0)
	move_child($BlackBackground, 0)
