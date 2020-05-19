extends AudioStreamPlayer

export(AudioStream) var menu_theme
export var phase_themes = []
export var laser = []
export var sphere = []
export var shock = []
export var shock_hit = []
export var magnet = []
export var missile_hit = []
export var bomber = []
export var player_damage = []
export var alert = []
export var red_arena = []

var players = []

func _ready():
	players = get_children()

func play_music(path):
	stream = path
	playing = true
	volume_db = linear2db(Global.get_music_volume())
	
func play_phase_theme(index):
	play_music(phase_themes[index])

func play_sound(sound_list):
	var the_player = players[players.size()-1]
	for player in players:
		if !player.playing:
			the_player = player
	
	the_player.stream = sound_list[rand_range(0, sound_list.size())]
	the_player.playing = true
	the_player.volume_db = linear2db(Global.get_sounds_volume())
