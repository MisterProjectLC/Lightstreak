extends Control

var health = 4
signal dead

func reduce_health():
	health -= 1
	$Lives.text = str(health) + "/4"
	
	if health <= 0:
		emit_signal("dead")


func set_time(new):
	var minutes = new / 60
	var seconds = new % 60
	
	if seconds < 10:
		$Timer.text = str(minutes) + ":0" + str(seconds)
	else:
		$Timer.text = str(minutes) + ":" + str(seconds)
