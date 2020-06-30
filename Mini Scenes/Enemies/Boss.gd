extends "res://Mini Scenes/Enemies/Enemy.gd"

var clock = 0
var _main
var first = true
var color = 0

func set_main():
	_main = get_tree().get_root().get_node("Main")

func _ready():
	$"AreaBlue/Sprite Blue".get_material().set_shader_param("max_health", _get_max_health())
	set_main()

func _process(delta):
	set_knockside(0)
	__process(delta)
	
	clock += delta
	if clock > 205:
		destroy()


func _pass_threshold():
	emit_signal("pass_threshold")
	emit_signal("pass_threshold")
	emit_signal("pass_threshold")
	destroy()


func _set_health(_new):
	._set_health(_new)
	$"AreaBlue/Sprite Blue".get_material().set_shader_param("health", _new)


func _on_AreaBlue_damaged():
	if color == 0:
		return
	
	color = 0
	_main.set_background(color)



func _on_AreaRed_damaged():
	if color == 1:
		return
	
	color = 1
	_main.call_deferred("spawn_enemy", "REDBLAST", 4 + (randi() % 3))
	_main.call_deferred("spawn_enemy", "REDBLAST", randi() % 4)
	_main.set_background(color)

func _on_AreaViolet_damaged():
	if color == 2:
		return
	color = 2

	_main.call_deferred("spawn_enemy", "VIOLETBLAST", 2, self)
	_main.set_background(color)
