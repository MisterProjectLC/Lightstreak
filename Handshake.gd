extends Node

var upnp = UPNP.new()
var handshake_receiver = PacketPeerUDP.new()
var handshake
var expected_text = ""
var sent_text = ""

func setup_receiver(port):
	handshake_receiver.listen(port)
	print_debug("listening on port " + str(port))

func host_send_handshake(args):
	handshake = PacketPeerUDP.new()
	handshake.connect_to_host(args[0], int(args[1]))
	expected_text = "test_client"
	sent_text = "test_host"
	handshake.put_packet(sent_text.to_utf8())
	$Timer.start(0.1)


func client_send_handshake(args):
	handshake = PacketPeerUDP.new()
	handshake.connect_to_host(args[0], int(args[1]))
	expected_text = "test_host"
	sent_text = "test_client"
	handshake.put_packet(sent_text.to_utf8())
	$Timer.start(0.1)


func _on_Timer_timeout():
	print_debug("connected: " + str(handshake.is_connected_to_host()))
	handshake.put_packet(sent_text.to_utf8())
	if (handshake_receiver.get_available_packet_count() <= 0):
		$Timer.start(0.25)
	
	var data = handshake_receiver.get_packet().get_string_from_utf8()
	print_debug(data)
	if data == expected_text:
		handshake.put_packet(sent_text.to_utf8())
		print_debug("RECEIVED")
		handshake.close()
		handshake_receiver.close()
