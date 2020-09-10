extends ColorRect

var paused = false
signal leave_game

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			if !paused:
				pause_game(true)
			else:
				pause_game(false)
		elif event.scancode == KEY_Q and paused:
			pause_game(false)
			emit_signal("leave_game")
			


func pause_game(pausing):
	paused = pausing
	get_tree().paused = pausing
	visible = pausing
