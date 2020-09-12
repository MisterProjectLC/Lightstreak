extends Label

var expected_text = ""
var options_text = false
var lang_text = false
var server_text = false
var already_activated = false

func _ready():
	expected_text = get_parent().text
	
	if expected_text.ends_with("<0-100>"):
		options_text = true
	
	elif expected_text.ends_with("<NAME>"):
		server_text = true
	
	elif expected_text.ends_with(">"):
		lang_text = true


func get_expected_text():
	return expected_text


func activate():
	already_activated = true
	self.set_modulate(Color(1, 1, 115.0/255.0, 1))
	self.text = expected_text


func update_expected_text(text):
	expected_text = text


func update_text(received_text):
	if already_activated:
		return false
	
	if received_text.length() == 0:
		self.text = ""
		return false
	
	if options_text:
		var args = received_text.rsplit(" ", false, 0)
		if (len(args) >= 2 and args[1].is_valid_integer() 
		and int(args[1]) >= 0 and int(args[1]) <= 100):
			received_text = args[0] + " <0-100>"
	
	elif server_text:
		var args = received_text.rsplit(" ", false, 0)
		if (len(args) >= 2):
			received_text = args[0] + " <NAME>"
	
	elif lang_text:
		var args = received_text.rsplit(" ", false, 0)
		if (len(args) >= 2 and (args[1] == "EN" or args[1] == "PT" 
		or args[1] == "DE")):
			received_text = args[0] + " <EN/PT/DE>"
	
	for i in range(received_text.length()):
		if expected_text.left(i+1) == received_text.left(i+1):
			self.text = expected_text.left(i+1)
		else:
			return false

	return true
