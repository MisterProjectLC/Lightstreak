extends AudioStreamPlayer

export(AudioStream) var menu_theme
export var phase_themes = []
export var laser = []
export var sphere = []
export var shock = []
export var shock_hit = []
export var player_damage = []
export var alert = []

var sounds = ['Sound', 'Sound2', 'Sound3']

func play_music(path):
	stream = path
	playing = true
	volume_db = linear2db(Global.get_music_volume())
	
func play_phase_theme(index):
	play_music(phase_themes[index])

func play_sound(sound_list, player):
	find_node(sounds[player-1]).stream = sound_list[rand_range(0, sound_list.size())]
	find_node(sounds[player-1]).playing = true
	find_node(sounds[player-1]).volume_db = linear2db(Global.get_sounds_volume())
