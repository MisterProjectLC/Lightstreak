extends "res://Scripts/Weapon.gd"

export var _speed = 1000

func ready():
	_weapon_offset = Vector2(0, -10)

func _process(delta):
	# move upwards
	position.y -= _speed*delta
	if position.y < 0:
		queue_free()


func damage(area):
	if area.has_method("take_damage"):
		area.take_damage(3)
		queue_free()
