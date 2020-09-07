extends "res://Scenes/Main.gd"

func ready():
	_weapon_list = [get_node('LaserTitle'), get_node('SphereTitle'), 
					get_node('ShockTitle'), get_node('MagnetTitle'),
					get_node('MissileTitle'), get_node('BombTitle'), 
					get_node('MachineTitle'), get_node('PushTitle'), 
					get_node('LightTitle')]
