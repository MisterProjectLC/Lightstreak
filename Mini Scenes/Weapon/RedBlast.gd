extends "res://Mini Scenes/Weapon/Blast.gd"

var _warning = 3
var _warned = false

signal send_alert

func _ready():
	emit_signal('send_alert', (">>>" + str(_lane) + "<<<"), 3)
	ready()

func _on_Blast_area_entered(area):
	if area.has_method("cannon_damage"):
		area.cannon_damage()

	if area.has_method("take_damage"):
		area.take_damage(5)

func _process(delta):
	if _fading:
		if $Blast/Sprite.get_modulate().a <= 0.1:
			if _warned  == true:
				emit_signal('send_alert', (">>>" + str(_lane) + "<<<"), 0)
				queue_free()
			else:
				_fading = false
		$Blast/Sprite.set_modulate($Blast/Sprite.get_modulate() + Color(0, 0, 0, -delta*_fading_speed))
	
	else:
		if $Blast/Sprite.get_modulate().a >= 0.5:
			if _warned  == false or $Blast/Sprite.get_modulate().a >= 1:
				_fading = true
	
		if _warned == false:
			$Blast/Sprite.set_modulate($Blast/Sprite.get_modulate() + Color(0, 0, 0, 5*delta*_fading_speed))
		else:
			$Blast/Sprite.set_modulate($Blast/Sprite.get_modulate() + Color(0, 0, 0, 15*delta*_fading_speed))
	
	if _warning > 0:
		_warning -= delta
		return
	
	if _warned == false:
		_warned = true
		Audio.play_sound(Audio.red_arena)
		$Blast/Collision.disabled = false
		$Blast/Sprite.set_modulate(Color($Blast/Sprite.get_modulate().r, $Blast/Sprite.get_modulate().g, 
										$Blast/Sprite.get_modulate().b, 0))
		_fading = false
