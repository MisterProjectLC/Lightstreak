extends "res://Scenes/Main.gd"

func setup_phase():
	_power_count = 9
	_cannon_count = 3

func summon_weapon(_index, _console_n, _lightstreak):
	Network._activated_power(_index, _console_n, _lightstreak)
	.summon_weapon(_index, _console_n, _lightstreak)

func _move_cannon(_cannon_n, _lane):
	Network._moved_cannon(_cannon_n, _lane)
	._move_cannon(_cannon_n, _lane)

func time_out():
	victory()

func leave_game():
	Network.cancel_connection()
	.leave_game()


func _on_MinionSpawner_passed_threshold():
	Network.took_damage()
	._on_MinionSpawner_passed_threshold()
