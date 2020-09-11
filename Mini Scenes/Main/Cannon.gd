extends Node2D

var _target_position
export var target_lane = 1

var _red_color = 0
var _redding = true
var _damaged = 0

export var move_speed = 1
export(Texture) var sprite
export(Texture) var highlight

signal damaged

func _ready():
	_target_position = position
	if has_node("Sprite"):
		$Sprite.texture = sprite
	if has_node("Highlight"):
		$Highlight.texture = highlight


func activate():
	visible = true
	$CollisionShape2D.disabled = false


func _process(delta):
	_move_to_position(move_speed*delta)
	if _damaged > 0:
		damaged_methods(delta)


func _move_to_position(speed):
	 position = position.linear_interpolate(_target_position, speed)


func damaged_methods(delta):
	if _redding:
		$Sprite.set_modulate($Sprite.get_modulate() + Color(0, -2*delta, -2*delta, 0))
		if $Sprite.get_modulate().g <= 0.1:
			_redding = false
	else:
		$Sprite.set_modulate($Sprite.get_modulate() + Color(0, 2*delta, 2*delta, 0))
		if $Sprite.get_modulate().g >= 1:
			_redding = true
	
	_damaged -= delta
	if _damaged <= 0:
		$Sprite.set_modulate(Color(1, 1, 1, 1))
		emit_signal("damaged", self, 0)


func cannon_damage():
	_damaged = 4
	emit_signal("damaged", self, _damaged)


# SETTERS/GETTERS -----------------------------------

func set_target_position(_new_position):
	_target_position = _new_position

func toggle_highlight(toggle):
	$Highlight.visible = toggle

func set_target_lane(_target_lane):
	self.target_lane = _target_lane

func get_target_lane():
	return target_lane
