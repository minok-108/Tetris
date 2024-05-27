extends Control

var statistics_view: bool = false #отличается от visible тем, что при ресете анимации становиться стразу false, а не после завершения анимации

func _ready():
	$Animation.play("RESET")
	$Animation.seek(0.2)

func start_animation():
	statistics_view = true
	visible = true
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(0.2)

func update_value_staristics():
	$ScrollContainer/Control/Statistics2D/BestScore.text = str(G.best_score_2d)
	$ScrollContainer/Control/Statistics2D/GamesPlayed.text = str(G.games_played_2d)
	$ScrollContainer/Control/Statistics2D/GamesWon.text = str(G.games_won_2d)
	$ScrollContainer/Control/Statistics2D/GamesLost.text = str(G.games_lost_2d)
	$ScrollContainer/Control/Statistics2D/BrokenLayers.text = str(G.broken_layers_2d)
	
	$ScrollContainer/Control/Statistics3D/BestScore.text = str(G.best_score_3d)
	$ScrollContainer/Control/Statistics3D/GamesPlayed.text = str(G.games_played_3d)
	$ScrollContainer/Control/Statistics3D/GamesWon.text = str(G.games_won_3d)
	$ScrollContainer/Control/Statistics3D/GamesLost.text = str(G.games_lost_3d)
	$ScrollContainer/Control/Statistics3D/BrokenLayers.text = str(G.broken_layers_3d)

func _on_button_close_pressed():
	if statistics_view == true:
		G.sound_button()
		
		close()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if statistics_view == true:
			G.sound_button()
			
			close()

func close():
	statistics_view = false
	
	$Animation.play("RESET")
	if G.setting_animation == true:
		await $Animation.animation_finished
	elif G.setting_animation == false:
		$Animation.seek(0.2)
	
	visible = false
