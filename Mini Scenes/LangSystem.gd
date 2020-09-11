extends Node

enum Language{PORTUGUES, ENGLISH, DEUTSCH}

var _linguas = []

func _ready():
	randomize()
	load_words()
	
	# put language-neutral words in every array
	for lingua in range(2, len(_linguas)):
		for diff in range(len(_linguas[1])):
			for word in _linguas[1][diff]:
				_linguas[lingua][diff].append(word)
	
func get_word(_diff, _lang):
	if _diff == 3:
		return "Light"
	else:
		return _linguas[_lang][_diff][randi() % _linguas[_lang][_diff].size()]

func load_words():
# warning-ignore:unused_variable
	_linguas.append([ [], [], [], [], 
					  [], [], [], [] ])
	for i in range(4):
		_linguas.append([ [], [], [] ])
	
	for i in range(len(_linguas)):
		var file = File.new()
		if not file.file_exists("res://Files/lingua" + str(i) + ".json"):
			return

		file.open("res://Files/lingua" + str(i) + ".json", File.READ)
		
		var helper = parse_json(file.get_as_text())

		_linguas[i][0] = helper['0']
		_linguas[i][1] = helper['1']
		_linguas[i][2] = helper['2']

		if i == 0:
			_linguas[i][3] = helper['3']
			_linguas[i][4] = helper['4']
			_linguas[i][5] = helper['5']
			_linguas[i][6] = helper['6']
			_linguas[i][7] = helper['7']
