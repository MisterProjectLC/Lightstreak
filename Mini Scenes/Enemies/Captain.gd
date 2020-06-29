extends "res://Mini Scenes/Enemies/Enemy.gd"

var minions = []

func _process(delta):
	__process(delta)

func _on_Detector_area_entered(area):
	if area.has_method("set_speed") and area != self and _stunned <= 0:
		area.set_speed(area.get_speed()*2)
		minions.append(area)


func _on_Detector_area_exited(area):
	if area.has_method("set_speed") and area != self:
		area.set_speed(area.get_speed()/2)
		minions.erase(area)

func destroy():
	for minion in minions:
		if minion:
			minion.set_speed(float(minion.get_speed())/2.0)
	.destroy()

func _on_Captain_changed_stunned(_new):
	if _new == 0:
		$Detector/Sprite.visible = true
		$Detector/Collision.disabled = false
		for minion in minions:
			if minion:
				minion.set_speed(minion.get_speed()*2)
	else:
		$Detector/Sprite.visible = false
		$Detector/Collision.disabled = true
		for minion in minions:
			if minion:
				minion.set_speed(float(minion.get_speed())/2.0)
