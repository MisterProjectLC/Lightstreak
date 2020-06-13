extends "res://Mini Scenes/Weapon/Projectile.gd"

func _ready():
	Audio.play_sound(Audio.bullet)
	ready()


func _on_Bullet_area_entered(area):
	damage(area)
