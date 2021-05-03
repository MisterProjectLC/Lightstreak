extends Node

const HOST_PORT = 31400
const CLIENT_PORT = 31401
const MAX_PLAYERS = 1
const NAT_URL = "nat-punchthrough.herokuapp.com"

var other_player_id = 0
var peer = null

var hosting = false
var hero_scene = "res://Scenes/MainMulti.tscn"
var villain_scene = "res://Scenes/MainEnemy.tscn"

# Our WebSocketClient instance
var ws_client = WebSocketClient.new()

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	ws_client.connect("connection_closed", self, "_closed")
	ws_client.connect("connection_error", self, "_closed")
	ws_client.connect("connection_established", self, "_connected")
	ws_client.connect("data_received", self, "_on_data")
	ws_client.verify_ssl = true
	
	# Initiate connection to the given URL.
	var err = ws_client.connect_to_url(NAT_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)


func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = ""):
	print("Connected with protocol: ", proto)


func _on_data():
	var data = ws_client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", data)
	
	if hosting:
		host_receive_response(data)
	else:
		client_receive_response(data)


func _process(delta):
	ws_client.poll()


# CREATE & HOST -------------------------------------

func create_server(server_name):
	hosting = true
	$Handshake.setup_receiver(HOST_PORT)
	peer = NetworkedMultiplayerENet.new()
	print_debug(peer.create_server(HOST_PORT, MAX_PLAYERS)) # this peer will be a server
	get_tree().set_network_peer(peer)
	
	var data = "host§" + server_name
	ws_client.get_peer(1).put_packet(data.to_utf8())
	print_debug("Server requisitado")


func host_receive_response(data):
	var args = data.split("§")
	if args.size() < 2:
		return
	$Handshake.host_send_handshake(args)


# JOIN  ------------------------------
func connect_to_server(server_name):
	hosting = false
	$Handshake.setup_receiver(CLIENT_PORT)
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var data = "client§" + server_name
	ws_client.get_peer(1).put_packet(data.to_utf8())


func client_receive_response(data):
	var args = data.split("§")
	if args.size() < 2:
		return
	
	$Handshake.client_send_handshake(args)
	peer = NetworkedMultiplayerENet.new()
	print_debug(peer.create_client(args[0], int(args[1]))) # this peer will be a client
	get_tree().set_network_peer(peer)
	print_debug("Cliente criado, tentando entrar em " + args[0] + ":" + args[1])


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
