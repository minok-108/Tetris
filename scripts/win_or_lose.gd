extends Control

##############
#Игра окончена
##############

func game_over(action):
	get_parent().stop_timers()
	get_parent().get_node("D/PhantomMap").clear()
	
	G.game = false
	
	var game_over_text = ""
	
	if action == "lose":
		if G.mode == "classic":
			game_over_text = tr("$Game_over!")
			$YourScore.text = tr("$Your_score:") + " " + str(get_parent().score)
		else:
			if G.d == "2d":
				G.games_lost_2d += 1
			elif G.d == "3d":
				G.games_lost_3d += 1
			
			game_over_text = tr("$You_lose!")
	elif action == "win":
		
		if G.d == "2d":
			G.games_won_2d += 1
		elif G.d == "3d":
			G.games_won_3d += 1
		
		game_over_text = tr("$You_win!")
	
	G.save()
	
	$Label.text = game_over_text
	
	$ColorRect.modulate = Color("00000000")
	$Label.visible_ratio = 0
	$YourScore.scale = Vector2(0, 0)
	$ButtonAgain.scale = Vector2(0, 0)
	$ButtonMenu.scale = Vector2(0, 0)
	
	visible = true
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(1)

func _on_button_again_pressed():
	G.sound_button()
	
	get_tree().paused = false
	visible = false
	
	get_parent().new_game()

func _on_button_menu_pressed():
	G.sound_button()
	
	G.game = false
	get_parent().stop_timers()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/Menu.tscn")
