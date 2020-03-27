extends Control

export(Texture) var sprite
export(PackedScene) var _weapon

export var _difficulty = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Icon.texture = sprite

func set_text(newText):
	$Label.text = newText

func get_text():
	return $Label.text
	
func get_difficulty():
	return _difficulty
	
func get_weapon():
	return _weapon
