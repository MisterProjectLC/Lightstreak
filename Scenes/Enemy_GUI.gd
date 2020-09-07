extends Control


func set_health(new):
	$Lives.text = str(new) + "/4"


func set_time(new):
	var minutes = new / 60
	var seconds = new % 60
	$Timer.text = str(minutes) + ":" + str(seconds)
