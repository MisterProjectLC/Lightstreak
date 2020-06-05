extends Node

var _phase = {}

func _ready():
	pass

func load_phase(_phase_id):
	var file = File.new()
	if not file.file_exists("res://Files/fase" + str(_phase_id) + ".json"):
		print("MANO SE VC TA VENDO ESSE ERRO É PQ O GODOT É CORNO, MANDA MENSAGEM PRO DANILO")
		return

	file.open("res://Files/fase" + str(_phase_id) + ".json", File.READ)
	var helper = parse_json(file.get_as_text())
	
	for key in helper.keys():
		_phase[key] = helper[key]

func get_phase():
	return _phase
