extends Sprite


var _target_position

func _ready():
	_target_position = position

func _process(delta):
	position = position.linear_interpolate(_target_position, delta)

func set_target_position(_new_position):
	_target_position = _new_position
