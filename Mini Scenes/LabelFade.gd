extends Label

var a = 0
var ascending = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ascending == true:
		a += delta
		if a >= 1:
			ascending = false
	else:
		a -= delta
		if a <= 0:
			ascending = true
		
	add_color_override("font_color", Color(1, 1, 1, sin(a)))
	pass
