extends Node2D

export(Texture) var _lightstreak_sprite
var _lightstreak = false

var _weapon_offset
var _weapon_lane

# Called when the node enters the scene tree for the first time.
func _ready():
	if _lightstreak and _lightstreak_sprite:
		$Sprite.texture = _lightstreak_sprite

func set_weapon_lane(_weapon_lane):
	self._weapon_lane = _weapon_lane

func get_weapon_lane():
	return _weapon_lane

func get_weapon_offset():
	return _weapon_offset
