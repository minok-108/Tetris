extends Control

func _on_continue_pressed():
	G.sound_button()
	
	pause_off()

func _on_again_pressed():
	G.sound_button()
	
	get_tree().paused = false
	visible = false
	
	get_parent().new_game()

func _on_statistics_pressed():
	G.sound_button()
	
	$Statistics.start_animation()

func _on_achievements_pressed():
	G.sound_button()
	
	$Achievements.start_animation()

func _on_settings_pressed():
	G.sound_button()
	
	$Settings.start_animation()

func _on_menu_pressed():
	G.sound_button()
	
	G.game = false
	get_parent().stop_timers()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/Menu.tscn")

func _on_pause_button_pressed():
	if G.game == true:
		G.sound_button()
		
		pause_on()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if G.game == true:
			if get_tree().paused == false:
				pause_on()
			elif get_tree().paused == true:
				pause_off()

func pause_on():
	$Statistics.update_value_staristics()
	$Achievements.update_value_achievements()
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(0.6)
	
	visible = true
	get_tree().paused = true

func pause_off():
	$Animation.play("RESET")
	if G.setting_animation == true:
		await $Animation.animation_finished
	elif G.setting_animation == false:
		$Animation.seek(0.6)
	
	visible = false
	get_tree().paused = false
