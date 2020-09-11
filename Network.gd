extends Node

const DEFAULT_IP = '127.0.0.1'
const PORT = 31400
const MAX_PLAYERS = 2

var other_player_id = 0

var hero_scene = "res://Scenes/MainMulti.tscn"
var villain_scene = "res://Scenes/MainEnemy.tscn"

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')

# CREATE & JOIN -------------------------------------

func create_server():
	# Peer = A PacketPeer implementation that should be passed to SceneTree.network_peer 
	# after being initialized as either a client or server. Events can then be handled by 
	# connecting to SceneTree signals.
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS) # this peer will be a server
	get_tree().set_network_peer(peer)
	print_debug("Server criado")


func connect_to_server():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, PORT) # this peer will be a client
	get_tree().set_network_peer(peer)
	print_debug("Server entrado")


# HANDLING RPCS ---------------------------------
remote func receive_spawner_info(id):
	if get_tree().is_network_server():
		other_player_id = id
		get_tree().change_scene(hero_scene)


remote func receive_power(_index, _console_n, _lightstreak):
	get_tree().get_root().get_node("MainEnemy").summon_weapon(_index, _console_n, _lightstreak)

remote func receive_enemy(enemy_name, enemy_lane):
	get_tree().get_root().get_node("MainMulti").spawn_enemy(enemy_name, enemy_lane)

# HANDLING SIGNALS --------------------------------------
func _connected_to_server():
	get_tree().change_scene(villain_scene)
	rpc('receive_spawner_info', get_tree().get_network_unique_id())


func _player_disconnected():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _activated_power(_index, _cannon, _lightstreak):
	rpc('receive_power', _index, _cannon, _lightstreak)


func _spawned_enemy(enemy_name, enemy_lane):
	rpc('receive_enemy', enemy_name, enemy_lane)




