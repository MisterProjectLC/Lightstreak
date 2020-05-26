extends "res://Scripts/Blast.gd"

func _ready():
	Audio.play_sound(Audio.red_arena)

func _process(delta):
	if !_fading:
		if $Blast/Sprite.get_modulate().a >= 1:
				_fading = true

		$Blast/Sprite.set_modulate($Blast/Sprite.get_modulate() + 
		Color(0, 0, 0, 15*delta*_fading_speed))


func _on_Blast_area_entered(area):
	if area.has_method("cannon_damage"):
		area.cannon_damage()

func i_am_vblast(): # gambiarra pesada
	pass
