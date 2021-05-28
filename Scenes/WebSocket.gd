extends Node

const NAT_URL = "gamedev-multiplayer-server.herokuapp.com"

var ws_client = WebSocketClient.new()
var server_checked = null
var max_players = 2

signal received_response
signal created
signal connected
signal not_connected
signal disconnected

func _ready():
	set_process(false)

func _process(delta):
	ws_client.poll()


# MANAGE CONNECTION ------------------------------

func setup(max_players):
	# Connect base signals to get notified of connection open, close, and errors.
	ws_client.connect("connection_closed", self, "_closed")
	ws_client.connect("connection_error", self, "_closed")
	ws_client.connect("connection_established", self, "_connected")
	ws_client.connect("data_received", self, "_on_data")
	ws_client.verify_ssl = true
	self.max_players = max_players
	
	# Initiate connection to the given URL.
	var err = ws_client.connect_to_url(NAT_URL)
	if err == OK:
		set_process(true)
	else:
		print_debug(err)


func _connected(proto = ""):
	print("Connected with protocol: ", proto)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)


# CLOSED SERVER ---
func enter_server(server_name, server_details = [], client_details = []):
	server_checked = [server_name, server_details]
	connect_to_server(server_name, client_details)


func create_server(server_name, server_details = []):
	server_checked = null
	var packet = ["host", server_name, str(max_players)]
	packet.append_array(server_details)
	send_packet(packet)


func connect_to_server(server_name, client_details = []):
	var packet = ["client", server_name]
	packet.append_array(client_details)
	send_packet(packet)


# OPEN SERVER ---
func enter_open_server(server_details = [], client_details = []):
	server_checked = [server_details]
	connect_to_open_server(client_details)


func create_open_server(server_details = []):
	server_checked = null
	var packet = ["host_open", str(max_players)]
	packet.append_array(server_details)
	send_packet(packet)


func connect_to_open_server(client_details = []):
	var packet = ["client_open"]
	packet.append_array(client_details)
	send_packet(packet)


func destroy_server():
	send_packet(["destroy"])


func close_networking():
	ws_client.disconnect_from_host()


# SEND PACKET ----------------------------
func send_packet(args):
	if args.empty():
		return
	
	var packet = args[0]
	for i in range(1, len(args)):
		packet += "§" + args[i]
	ws_client.get_peer(1).put_packet(packet.to_utf8())


# RECEIVE RESPONSE -----------------------
func _on_data():
	var data = ws_client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", data)
	var args = data.split("§")
	
	if args.empty():
		return
	
	match(args[0]):
		"data":
			args.remove(0)
			emit_signal("received_response", args)
		
		"not_connected":
			if server_checked:
				if server_checked.size() > 1:
					create_server(server_checked[0], server_checked[1])
				else:
					create_open_server(server_checked[0])
			else:
				ws_event(args)
		
		_:
			ws_event(args)


func ws_event(args):
	var event = args[0]
	args.remove(0)
	emit_signal(event, args)
