extends "res://Mini Scenes/Weapon/Weapon.gd"

var _color
signal hit_enemy
var enemies_hit = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_weapon_offset = Vector2(0, 0)
	Audio.play_sound(Audio.shock)


func _on_Shock_area_entered(area):
	if area.has_method("take_damage") and not area in enemies_hit:
		Audio.play_sound(Audio.shock_hit)
		area.take_damage(1)
		area.set_stunned(15)
		emit_signal('hit_enemy', area)
		#queue_free()

func append_to_hit(received):
	enemies_hit = received
