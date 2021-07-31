extends Node

const MAX_PLAYERS = 2
const HERO_SCENE = "res://Scenes/MainMulti.tscn"
const VILLAIN_SCENE = "res://Scenes/MainEnemy.tscn"

var current_server_name = ""
var hero = false
var hosting = false

signal connection_failed

# SETUP ----------------------------------

func _ready():
	$WebSocket.setup(MAX_PLAYERS)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		cancel_connection()
		$WebSocket.close_networking()
		get_tree().quit()


func cancel_connection():
	if hosting:
		$WebSocket.send_packet(["destroy", current_server_name])


# MANAGE CONNECTION --------------------------------

func enter_server(_hero, server_name = null):
	var server_details = []
	var client_details = []
	hero = _hero
	if hero:
		server_details.append('H')
		client_details.append('V')
	else:
		server_details.append('V')
		client_details.append('H')
	if server_name != null:
		current_server_name = server_name
		$WebSocket.enter_server(current_server_name, server_details, client_details)
	else:
		$WebSocket.enter_open_server(server_details, client_details)


func _on_WebSocket_created(args):
	current_server_name = args[0]
	hosting = true


func _on_WebSocket_connected(args):
	current_server_name = args[0]
	if hero and (hosting == (args[1] == "H")):
		get_tree().change_scene(HERO_SCENE)
	elif !hero and (hosting == (args[1] == "V")):
		get_tree().change_scene(VILLAIN_SCENE)


func _on_WebSocket_not_connected(_args):
	hosting = false
	emit_signal("connection_failed")


func _on_WebSocket_disconnected(_args):
	hosting = false
	get_tree().change_scene("res://Scenes/Main.tscn")


# MANAGE MESSAGES ---------------------------------
func send_game_message(args):
	var sent_args = ["data", current_server_name]
	for arg in args:
		sent_args.append(arg)
	$WebSocket.send_packet(sent_args)


func _on_WebSocket_received_response(args):
	if args.empty():
		return
	
	var message = args[0]
	args.remove(0)
	match(message):
		"power":
			receive_power(args)
		"movem":
			receive_movem(args)
		"enemy":
			receive_enemy(args)
		"damage":
			receive_damage()
		"timeout":
			timeout()



# HANDLING RPCS ---------------------------------
func receive_power(args):
	var _index = int(args[0])
	var _console_n = int(args[1])
	var _lightstreak = bool(args[2])
	get_tree().get_root().get_node("MainEnemy").summon_weapon(_index, _console_n, _lightstreak)


func receive_movem(args):
	var _cannon = int(args[0])
	var _lane = int(args[1])
	get_tree().get_root().get_node("MainEnemy")._move_cannon(_cannon, _lane)


func receive_enemy(args):
	var enemy_name = args[0]
	var enemy_lane = int(args[1])
	get_tree().get_root().get_node("MainMulti").spawn_enemy(enemy_name, enemy_lane)


func receive_damage():
	get_tree().get_root().get_node("MainEnemy").receive_damage()


func timeout():
	get_tree().get_root().get_node("MainMulti").time_out()



# HANDLING SIGNALS --------------------------------------
func _activated_power(_index, _cannon, _lightstreak):
	send_game_message(["power", str(_index), str(_cannon), str(_lightstreak)])

func _moved_cannon(_cannon, _lane):
	send_game_message(["movem", str(_cannon), str(_lane)])

func _spawned_enemy(enemy_name, enemy_lane):
	send_game_message(["enemy", enemy_name, str(enemy_lane)])

func took_damage():
	send_game_message(["damage"])

func timed_out():
	send_game_message(["timeout"])
