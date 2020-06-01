extends Node2D

var _weapon_offset
var _weapon_lane

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_weapon_lane(_weapon_lane):
	self._weapon_lane = _weapon_lane


func get_weapon_lane():
	return _weapon_lane

func get_weapon_offset():
	return _weapon_offset
