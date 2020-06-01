extends TextureRect

var activated = false
var clock = 0

func start():
	activated = true
	
func _process(delta):
	if !activated:
		return
	
	clock += delta
	
	if clock > 0.35:
		clock = 0
		visible = !visible

func destroy():
	queue_free()
