extends "res://Scripts/Weapon.gd"

var _fading_speed = 2
var _knockside = Global.get_lane_x_increase()

func _ready():
	_weapon_offset = Vector2(0, -462)
	Audio.play_sound(Audio.magnet, 1)


func _process(delta):
	if _knockside > 0:
		var speed = 200*delta
		$MagnetLeft.position.x += speed
		$MagnetRight.position.x -= speed
		_knockside -= speed

	else:
		$Sprite.set_modulate($Sprite.get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
		if $Sprite.get_modulate().a <= 0.1:
			queue_free()


func set_weapon_lane(_weapon_lane):
	.set_weapon_lane(_weapon_lane)
	
	if _weapon_lane != 0:
		$MagnetLeft.visible = true
		
	if _weapon_lane != 6:
		$MagnetRight.visible = true


func _on_MagnetLeft_area_entered(area):
	apply_knockside(area, 1)


func _on_MagnetRight_area_entered(area):
	apply_knockside(area, -1)


func apply_knockside(area, direction):
	if area.has_method("set_knockside") and _knockside > Global.get_lane_x_increase()-5:
		#Audio.play_sound(Audio.magnet, 2)
		area.set_knockside(direction)
		area.take_damage(1)
		#emit_signal('hit_enemy')
