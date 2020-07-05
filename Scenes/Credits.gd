extends Control

var outlines = [
"Credits", "Gamedev Ufscar", "MasterProject", "MasterProject2", "Art/Leeroy", "Art/MasterProject3",
"Art/CreativeStall", "Art/Zero400539", "Art/frogatto", "Music/SebastianWolff", "Music/dCi", "Music/dCi2",
"Music/dCi3", "Music/dCi4", "Music/JerryTerry", "Music/HydroDalek", "Music/DaftPunk", "Music/PandaBear",
"Music/sabife", "Music/sabife2", "Music/sabife3", "Music/Basshunter", "Music/Swimmer One", "Music/kr1z", 
"Music/Kairamen", "Music/Scoutellite", "Music/Syrsa", "Music/XenoGenic", "Music/TheLivingTombstone", 
"Music/excalibur"]

var animations = ["start"]
var current_anim = 0
var typed_count = 0

func _ready():
	Audio.play_music(Audio.credits_theme)
	$AnimationPlayer.play("start")
	for i in range(outlines.size()):
		outlines[i] = find_outline(outlines[i])


func _command_typed(_id, text):
	var to_exclude = []
	print_debug(text)
	for outline in outlines:
		#print_debug(text, " ", outline.get_expected_text())
		if text == outline.get_expected_text():
			outline.activate()
			typed_count += 1
			to_exclude.append(outline)
	
	for excluded in to_exclude:
		outlines.erase(excluded)


func _update_outlines(text):
	for outline in outlines:
		outline.update_text(text)


func _on_AnimationPlayer_animation_finished(anim_name):
	current_anim += 1
	if current_anim >= len(animations):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		Audio.stop()
	else:
		$AnimationPlayer.play(animations[current_anim])


func find_outline(text):
	text = "./" + text + "/Outline"
	return get_node(text)
