extends Control

func _ready():
	$Statistics.update_value_staristics()
	$Achievements.update_value_achievements()
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(1)

func _on_play_pressed():
	G.sound_button()
	
	if $Buttons/Play/Modes.visible == true:
		$Buttons/Play/Modes/Animation.play("RESET")
		
		if G.setting_animation == true:
			await $Buttons/Play/Modes/Animation.animation_finished
		elif G.setting_animation == false:
			$Buttons/Play/Modes/Animation.seek(0.2)
			
		$Buttons/Play/Modes.visible = false
	
	elif $Buttons/Play/Modes.visible == false:
		$Buttons/Play/Modes.visible = true
		$Buttons/Play/Modes/Animation.play("PLAY")
	
		if G.setting_animation == false:
			$Buttons/Play/Modes/Animation.seek(0.2)

func _on_classic_pressed():
	G.sound_button()
	
	G.d = "2d"
	G.mode = "classic"
	
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_pressed():
	G.sound_button()
	
	G.d = "3d"
	G.mode = "classic"
	
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_levels_pressed():
	G.sound_button()
	
	$Levels.start_animation()

func _on_statistics_pressed():
	G.sound_button()
	
	$Statistics.start_animation()

func _on_achievements_pressed():
	G.sound_button()
	
	$Achievements.start_animation()

func _on_settings_pressed():
	G.sound_button()
	
	$Settings.start_animation()

func _on_quit_pressed():
	get_tree().quit()

func _on_link_discord_pressed():
	if G.completed_achievements[23] != true:
		G.completed_achievements[23] = true
		$Achievements.update_value_achievements()
