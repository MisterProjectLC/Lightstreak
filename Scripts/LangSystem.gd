extends Node

enum Language{PORTUGUES, ENGLISH, DEUTSCH}

var _vortoj = [['Mini', 'Watt', 'Ego', 'Web', 'Ok'], 
			['Wrona', 'Dvorak', 'Hacker', 'Turing', 'Kraken', 'Oxford', 'Online', 'Super',
			'Newton', 'Design'], []]
var _palavras = [['Caos', 'Triz', 'Fogo', 'Nave', 'Luz', 'Fim', 'Jogo', 'Sol', 'Lua',
				'Zero', 'Um', 'Dois', 'Seis', 'Sete', 'Oito', 'Nove', 'Dez', 'Base',
				'Hoje', 'Foco', 'Sim', 'Nada', 'Ato', 'Vida', 'Paz', 'Mar',
				'Tema', 'Era', 'Raio', 'Caso', 'Lei', 'Ar', 'Eco', 'Asa', 'Ata', 'Tom',
				'Foz', 'Dom', 'Bem', 'Mau', 'Via', 'Som', 'Ira'],
				['Texto', 'Magia', 'Coral', 'Portal', 'Assis', 'Lobato', 'Forum',
				'Equipe', 'Disco', 'Musica', 'Caneta', 'Terra', 'Marca', 'Tumba',
				'Codigo', 'Escola', 'Espada', 'Classe', 'Navio', 'Dragao', 'Porta',
				'Prata', 'Bronze', 'Ferro', 'Carta', 'Disco', 'Tempo', 'Morte',
				'Vento', 'Perigo', 'Livro', 'Ataque', 'Regra', 'Estado', 'Animal',
				'Frota', 'Poder', 'Quatro', 'Cinco', 'Listra', 'Linha', 'Corte', 'Escuro', 
				'Pauta', 'Coisa', 'Ontem'], []]
var _words = [['Easy', 'Star', 'Club', 'Card', 'New', 'Far', 'End', 'Time', 'Life', 'City', 'Word', 'Car', 
			'Run'], 
			['Color', 'System', 'Scene', 'Weight', 'Coffee', 'Trial', 'Focus', 'Light',
				'Debuff', 'School', 'Worker', 'System', 'Death'], []]
var _worter = [['Wort', 'Zeit', 'Bau', 'Ja', 'Nein', ''], 
		['Farbe', 'Goethe', 'Faust', 'Werner', 'Feuer', 'Wasser', 'Licht'], []]

func _ready():
	randomize()
	for _diff in range(len(_vortoj)):
		for _vorto in _vortoj[_diff]:
			_palavras[_diff].append(_vorto)
			_words[_diff].append(_vorto)
			_worter[_diff].append(_vorto)
	
func get_word(_diff, _lang):
	match _lang:
		Language.PORTUGUES:
			return _palavras[_diff][randi() % _palavras[_diff].size()]
		Language.ENGLISH:
			return _words[_diff][randi() % _words[_diff].size()]
		Language.DEUTSCH:
			return _worter[_diff][randi() % _worter[_diff].size()]
