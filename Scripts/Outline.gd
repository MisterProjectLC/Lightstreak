extends Node

var expected_text = ""
var options_text = false

func _ready():
	expected_text = get_parent().text
	
	if expected_text.ends_with(">"):
		options_text = true

func update_text(received_text):
	if received_text.length() == 0:
		self.text = ""
		return false
	
	for i in range(received_text.length()):
		if expected_text.left(i+1) == received_text.left(i+1):
			self.text = expected_text.left(i+1)
		else:
			return false

	return true
