extends Control


func set_health(new):
	$Lives.text = str(new) + "/4"


func set_time(new):
	var minutes = new / 60
	var seconds = new % 60
	
	if seconds < 10:
		$Timer.text = str(minutes) + ":0" + str(seconds)
	else:
		$Timer.text = str(minutes) + ":" + str(seconds)
