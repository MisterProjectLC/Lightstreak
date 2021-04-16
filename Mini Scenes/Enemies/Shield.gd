extends Area2D

var clock = 0
var teal = Color(212.0/255.0, 24.0/255.0, 24.0/255.0, 0.5)
var protected = []
var stunned = false

var off_cooldown_duration = 4

func _ready():
	protect(get_parent(), true)

func enable():
	$Sprite.visible = true
	$Collision.call_deferred("set", "disabled", false)
	$Sprite.set_modulate(teal)

func disable():
	$AnimationPlayer.play("blink")
	$Collision.call_deferred("set", "disabled", true)
	for minion in protected:
		minion.set_protected(false)
	protected.clear()


func protect(area, protect):
	area.set_protected(protect)
	if protect:
		protected.append(area)
	else:
		protected.erase(area)


func take_damage(_damage):
	disable()
	$Timer.start(off_cooldown_duration)

func _on_Shield_area_entered(area):
	if area.has_method("set_protected"):
		protect(area, true)

func _on_Shield_area_exited(area):
	if area.has_method("set_protected"):
		protect(area, false)


func _on_Guardian_changed_stunned(_new):
	stunned = _new
	if stunned:
		disable()
	else:
		enable()

func _on_Timer_timeout():
	enable()


func set_stunned(damage):
	pass
