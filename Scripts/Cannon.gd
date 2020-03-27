extends Node2D

var _target_position
export var move_speed = 1
export(Texture) var sprite
export(Texture) var highlight

func _ready():
	_target_position = position
	$Sprite.texture = sprite
	$Highlight.texture = highlight
	pass # Replace with function body.


func _process(delta):
	_move_to_position(move_speed*delta)


func _move_to_position(speed):
	 position = position.linear_interpolate(_target_position, speed)

func set_target_position(_new_position):
	_target_position = _new_position

func toggle_highlight(toggle):
	$Highlight.visible = toggle
