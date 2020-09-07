extends "res://Scenes/Main.gd"

var current_lane = 0

func ready():
	_weapon_list = [get_node('TrooperTitle'), get_node('TankTitle'), 
					get_node('SpeederTitle'), get_node('HackerTitle'),
					get_node('BomberTitle'), get_node('SlickTitle'), 
					get_node('GuardianTitle'), get_node('CaptainTitle')]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Console_tab_console(_lane):
	$LaneOverlay.set_target_position(Vector2(Global.get_lane_x(_lane), Global.get_lane_y()))
