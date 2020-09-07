extends Node

const DEFAULT_IP = '127.0.0.1'
const PORT = 31400
const MAX_PLAYERS = 2

var players = {}

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


func connect_to_server():
	#
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, PORT) # this peer will be a client
	get_tree().set_network_peer(peer)

# HANDLING SIGNALS --------------------------------------

func _connected_to_server():
	get_tree().change_scene("res://Scenes/MainMulti.tscn")

func _player_disconnected():
	get_tree().change_scene("res://Scenes/Main.tscn")
