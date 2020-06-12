extends "res://Mini Scenes/Weapon/Projectile.gd"

func _ready():
	Audio.play_sound(Audio.bullet)
	ready()
	
	if _lightstreak:
		$Sprite.texture = _lightstreak_sprite

func _on_Bullet_area_entered(area):
	damage(area)
