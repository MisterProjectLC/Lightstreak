extends HTTPRequest

func request_ip():
	request("https://api.my-ip.io/ip", [], true)

