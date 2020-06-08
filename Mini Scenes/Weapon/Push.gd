extends "res://Mini Scenes/Weapon/Projectile.gd"

var pushed_minions = []

func _ready():
	Audio.play_sound(Audio.sphere)
	ready()

func _process(delta):
	for minion in pushed_minions:
		minion.position.y = position.y - 28

func _on_Push_area_entered(area):
	if not area in pushed_minions and area.has_method("take_damage"):
		area.take_damage(1)
		pushed_minions.append(area)


func _on_Push_area_exited(area):
	if area in pushed_minions:
		pushed_minions.erase(area)
