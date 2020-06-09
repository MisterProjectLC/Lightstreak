extends Area2D

var clock = 0
var shield_phase = 0
var teal = Color(212.0/255.0, 24.0/255.0, 24.0/255.0, 0.5)
var protected = []
var stunned = false

var off_cooldown_duration = 20

func _ready():
	protect(get_parent(), true)

func _process(delta):
	position.x = 0
	position.y = 0
	
	if shield_phase != 0:
		clock += delta
		if clock >= 0.1:
			shield_phase -= 1
			update_shield_phase()
			clock = 0

func update_shield_phase():
	if shield_phase == 0 or stunned:
		return
	
	if shield_phase == 1:
		visible = true
		$Collision.disabled = false
		$Sprite.set_modulate(teal)
		return
	else:
		$Collision.disabled = true
		for minion in protected:
			minion.set_protected(false)
		protected.clear()
	
	if shield_phase <= off_cooldown_duration:
		visible = false
		return
	
	if shield_phase % 2 == 0:
		$Sprite.set_modulate(Color(1, 0, 0, 0.5))
	else:
		$Sprite.set_modulate(Color(0, 0, 0, 0.5))

func take_damage(damage):
	shield_phase = off_cooldown_duration+4
	
func set_stunned(damage):
	take_damage(damage)

func _on_Shield_area_entered(area):
	if area.has_method("set_protected"):
		protect(area, true)

func _on_Shield_area_exited(area):
	if area.has_method("set_protected"):
		protect(area, false)

func protect(area, protect):
	area.set_protected(protect)
	if protect:
		protected.append(area)
	else:
		protected.erase(area)

func _on_Guardian_changed_stunned(_new):
	stunned = _new
