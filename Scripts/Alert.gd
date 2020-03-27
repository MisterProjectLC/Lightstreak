extends TextureRect

var _priority = 0


func _ready():
	pass

func set_text(text):
	$Label.text = text

func get_text():
	return $Label.text

func set_priority(priority):
	self._priority = priority
	
func get_priority():
	return _priority
	
func damage():
	$Damage.visible = true
