extends Node

const PORT = 31400
const MAX_PLAYERS = 1

var other_player_id = 0
var peer = null
var server_ip = '127.0.0.1'

var hero_scene = "res://Scenes/MainMulti.tscn"
var villain_scene = "res://Scenes/MainEnemy.tscn"

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')

# CREATE & JOIN -------------------------------------

func create_server():
	# Peer = A PacketPeer implementation that should be passed to SceneTree.network_peer 
	# after being initialized as either a client or server. Events can then be handled by 
	# connecting to SceneTree signals.
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS) # this peer will be a server
	get_tree().set_network_peer(peer)
	print_debug("Server criado")

func set_server_ip(_ip):
	server_ip = _ip


func connect_to_server():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, PORT) # this peer will be a client
	get_tree().set_network_peer(peer)
	print_debug("Cliente criado")


func close_connection():
	if peer != null:
		peer.close_connection()


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
