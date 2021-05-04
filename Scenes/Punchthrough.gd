extends Node

const NAT_URL = "nat-punchthrough.herokuapp.com"

var HOST_PORT = 8910
var CLIENT_PORT = 8911
var MAX_PLAYERS = 1
var my_ip = ""

var other_player_id = 0
var current_server_name = ""

var hosting = false

# Our WebSocketClient instance
var ws_client = WebSocketClient.new()

signal punchthrough_finished
signal received_destination

func _on_IPGetter_request_completed(result, response_code, headers, body):
	my_ip = body.get_string_from_utf8()
	print_debug(my_ip)


func _ready():
	set_process(false)


func setup(host, client, maxplayers):
	HOST_PORT = host
	CLIENT_PORT = client
	MAX_PLAYERS = maxplayers
	
	# Connect base signals to get notified of connection open, close, and errors.
	ws_client.connect("connection_closed", self, "_closed")
	ws_client.connect("connection_error", self, "_closed")
	ws_client.connect("connection_established", self, "_connected")
	ws_client.connect("data_received", self, "_on_data")
	ws_client.verify_ssl = true
	
	$IPGetter.request_ip()
	
	# Initiate connection to the given URL.
	var err = ws_client.connect_to_url(NAT_URL)
	if err == OK:
		set_process(true)


func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = ""):
	print("Connected with protocol: ", proto)


func _on_data():
	var data = ws_client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", data)
	
	receive_response(data)


func _process(delta):
	ws_client.poll()


func cancel_connection():
	var data = "destroy§" + current_server_name
	ws_client.get_peer(1).put_packet(data.to_utf8())


func receive_response(data):
	var args = data.split("§")
	if args.size() < 2:
		return
	
	ws_client.disconnect_from_host()
	$Handshake.send_handshake(args, hosting)
	emit_signal("received_destination", args)


func _on_Handshake_handshake_finished():
	emit_signal("punchthrough_finished")

# CREATE & HOST -------------------------------------

func create_server(server_name):
	hosting = true
	$Handshake.setup_receiver(HOST_PORT)
	
	var data = "host§" + server_name  + "§" + my_ip + "§" + IP.get_local_addresses()[1] + "§" + str(HOST_PORT)
	current_server_name = server_name
	ws_client.get_peer(1).put_packet(data.to_utf8())
	print_debug("Server requisitado\n" + data)


# JOIN  ------------------------------
func connect_to_server(server_name):
	hosting = false
	$Handshake.setup_receiver(CLIENT_PORT)
	var data = "client§" + server_name + "§" + my_ip + "§" + IP.get_local_addresses()[1] + "§" + str(CLIENT_PORT)
	ws_client.get_peer(1).put_packet(data.to_utf8())
