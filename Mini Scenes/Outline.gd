extends Node

var expected_text = ""
var options_text = false

func _ready():
	expected_text = get_parent().text
	
	if expected_text.ends_with("<0-100>"):
		options_text = true

func update_expected_text(text):
	expected_text = text

func update_text(received_text):
	if received_text.length() == 0:
		self.text = ""
		return false
	
	if options_text:
		var args = received_text.rsplit(" ", false, 0)
		if (len(args) >= 2 and args[1].is_valid_integer() 
		and int(args[1]) >= 0 and int(args[1]) <= 100):
			received_text = args[0] + " <0-100>"
			print("number found")
	
	for i in range(received_text.length()):
		if expected_text.left(i+1) == received_text.left(i+1):
			self.text = expected_text.left(i+1)
		else:
			return false

	return true
