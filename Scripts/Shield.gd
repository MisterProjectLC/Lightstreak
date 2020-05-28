extends Area2D

var clock = 0
var shield_phase = 0
var teal = Color(212.0/255.0, 24.0/255.0, 24.0/255.0, 0.5)
var protected = []

var off_cooldown_duration = 20

func _ready():
	protect(get_parent())

func _process(delta):
	if shield_phase != 0:
		clock += delta
		if clock >= 0.1:
			shield_phase -= 1
			update_shield_phase()
			clock = 0

func update_shield_phase():
	if shield_phase == 0:
		return
	
	if shield_phase == 1:
		visible = true
		$Collision.disabled = false
		$Sprite.set_modulate(teal)
		return
	
	if shield_phase <= off_cooldown_duration:
		visible = false
		$Collision.disabled = true
		for minion in protected:
			minion.set_protected(false)
		protected.clear()
		return
	
	if shield_phase % 2 == 0:
		$Sprite.set_modulate(Color(1, 0, 0, 0.5))
	else:
		$Sprite.set_modulate(Color(0, 0, 0, 0.5))

func take_damage(damage):
	shield_phase = off_cooldown_duration+4

func _on_Shield_area_entered(area):
	if area.has_method("set_protected"):
		protect(area)

func protect(area):
	area.set_protected(true)
	protected.append(area)
