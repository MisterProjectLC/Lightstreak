extends "res://Mini Scenes/Weapon/Weapon.gd"

var _fading_speed = 2
var _knockside = Global.get_lane_x_increase()
export(Texture) var _lightstreak_magnet_sprite

func _ready():
	_weapon_offset = Vector2(0, -462)
	Audio.play_sound(Audio.magnet)
	

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


func adjust_lightstreak():
	if _lightstreak:
		$Sprite.texture = _lightstreak_sprite
		$MagnetLeft/Sprite.texture = _lightstreak_magnet_sprite
		$MagnetRight/Sprite.texture = _lightstreak_magnet_sprite

func apply_knockside(area, direction):
	if area.has_method("set_knockside") and _knockside > Global.get_lane_x_increase()-5:
		#Audio.play_sound(Audio.magnet, 2)
		area.set_knockside(direction)
		area.take_damage(1)
		#emit_signal('hit_enemy')
