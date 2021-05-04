extends Node

var handshake = PacketPeerUDP.new()

signal handshake_finished

func setup_receiver(port):
	handshake.listen(port)
	print_debug("listening on port " + str(port))


func send_handshake(args, hosting):
	handshake.set_dest_address(args[0], int(args[1]))
	handshake.put_packet("Sent1".to_utf8())
	handshake.put_packet("Sent2".to_utf8())
	
	var err = handshake.wait() # wait for server ok
	if (err == OK):
		print_debug("Handshake sent successfully.")
		var packet = handshake.get_packet()
		$Timer.start(0.1)
	else:
		print_debug("Handshake error!")
		handshake.close()


func _on_Timer_timeout():
	handshake.put_packet("Sent3".to_utf8())
	if (handshake.get_available_packet_count() <= 0):
		$Timer.start(0.25)
		return
	
	var data = handshake.get_packet().get_string_from_utf8()
	print_debug("Received handshake")
	print_debug(data)
	handshake.put_packet("Sent4".to_utf8())
	handshake.close()
	emit_signal("handshake_finished")
