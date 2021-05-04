extends Node

const HOST_PORT = 8910
const CLIENT_PORT = 8911
const MAX_PLAYERS = 1

var my_ip = ""
var dest_ip = ""
var dest_port = ""

var other_player_id = 0
var peer = null
var current_server_name = ""

var hero = false
var hero_scene = "res://Scenes/MainMulti.tscn"
var villain_scene = "res://Scenes/MainEnemy.tscn"

func _ready():
	$Punchthrough.setup(HOST_PORT, CLIENT_PORT, MAX_PLAYERS)


func cancel_connection():
	$Punchthrough.cancel_connection()


func _on_Punchthrough_punchthrough_finished():
	print_debug("Punched through")
	if hero:
		print_debug("Creating server")
		peer = NetworkedMultiplayerENet.new()
		peer.create_server(HOST_PORT, MAX_PLAYERS)
		get_tree().set_network_peer(peer)
	else:
		print_debug("Creating client")
		$Timer.start(1)


func _on_Punchthrough_received_destination(args):
	if args.size() < 2:
		return
	
	dest_ip = args[0]
	dest_port = args[1]


# CREATE & HOST -------------------------------------

func create_server(server_name):
	hero = true
	$Punchthrough.create_server(server_name)


# JOIN  ------------------------------

func connect_to_server(server_name):
	hero = false
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	$Punchthrough.connect_to_server(server_name)


func _on_Timer_timeout():
	peer = NetworkedMultiplayerENet.new()
	var status = peer.create_client(dest_ip, int(dest_port))
	get_tree().set_network_peer(peer)
	
	if status != OK:
		$Timer.start(1)


# HANDLING RPCS ---------------------------------
remote func receive_spawner_info(id):
	if get_tree().is_network_server():
		print_debug(str(id), " ", peer.get_peer_address(id), " ", str(peer.get_peer_port(id)))
		other_player_id = id
		get_tree().change_scene(hero_scene)


remote func receive_power(_index, _console_n, _lightstreak):
	get_tree().get_root().get_node("MainEnemy").summon_weapon(_index, _console_n, _lightstreak)

remote func receive_movem(_cannon, _lane):
	get_tree().get_root().get_node("MainEnemy")._move_cannon(_cannon, _lane)

remote func receive_damage():
	get_tree().get_root().get_node("MainEnemy")._receive_damage()

remote func receive_enemy(enemy_name, enemy_lane):
	get_tree().get_root().get_node("MainMulti").spawn_enemy(enemy_name, enemy_lane)

remote func time_out():
	get_tree().get_root().get_node("MainMulti").time_out()

# HANDLING SIGNALS --------------------------------------
func _connected_to_server():
	get_tree().change_scene(villain_scene)
	rpc('receive_spawner_info', get_tree().get_network_unique_id())

func _player_disconnected(_a = ''):
	if other_player_id != 0:
		get_tree().change_scene("res://Scenes/Main.tscn")


func _activated_power(_index, _cannon, _lightstreak):
	rpc('receive_power', _index, _cannon, _lightstreak)

func _moved_cannon(_cannon, _lane):
	rpc('receive_movem', _cannon, _lane)

func _spawned_enemy(enemy_name, enemy_lane):
	rpc('receive_enemy', enemy_name, enemy_lane)

func took_damage():
	rpc('receive_damage')

func timed_out():
	rpc('time_out')
