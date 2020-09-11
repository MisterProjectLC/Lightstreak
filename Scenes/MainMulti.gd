extends "res://Scenes/Main.gd"

func setup_phase():
	_power_count = 9
	_cannon_count = 3

func summon_weapon(_index, _console_n, _lightstreak):
	Network._activated_power(_index, _console_n, _lightstreak)
	.summon_weapon(_index, _console_n, _lightstreak)
