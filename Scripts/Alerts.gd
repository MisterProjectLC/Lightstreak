extends Control

var alerts_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Alphabet").connect('updated_alphabet', self, 'hacker_alert')
	alerts_list = [find_node('Alert1'), find_node('Alert2'), find_node('Alert3')]

func alert(message, priority):
	if priority == 0:
		erase_text(message)
	else:
		update_text(message, priority, false)

func hacker_alert(a, b, adding):
	if adding:
		update_text(OS.get_scancode_string(a) + ' <-> ' + OS.get_scancode_string(b), 2, false)
	else:
		erase_text(OS.get_scancode_string(a) + ' <-> ' + OS.get_scancode_string(b))

func red_alert(lane, incoming):
	if incoming:
		update_text('>>> ' + lane + ' <<<', 3, false)
	else:
		erase_text('>>> ' + lane + ' <<<')

func damage_alert():
	update_text('', 100, true)

func update_text(text, priority, dmg):
	Audio.play_sound(Audio.alert, 3)
	var alert = get_available_alert(priority)
	if alert == null:
		return
	
	alert.set_text(text)
	alert.set_priority(priority)
	if dmg:
		alert.damage()

func erase_text(text):
	var alerts = get_matching_alerts(text)
	if len(alerts) == 0:
		return
	
	for alert in alerts:
		alert.set_text('')
		alert.set_priority(0)


func get_available_alert(priority):
	for alert in alerts_list:
		if alert.get_priority() == 0:
			return alert
	
	for alert in alerts_list:
		if alert.get_priority() < priority:
			return alert
	return null

func get_matching_alerts(text):
	var alerts = []
	
	for alert in alerts_list:
		if alert.get_text() == text:
			alerts.append(alert)
	return alerts
