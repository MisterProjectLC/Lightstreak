extends Node2D

var _fading = false
var _fading_speed = 2

var _lane = 1

# Called when the node enters the scene tree for the first time.
func ready():
	position.y = Global.get_lane_y()/2


func set_lane(_lane):
	self._lane = _lane
