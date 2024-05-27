extends Control

var settings_view: bool = false #отличается от visible тем, что при ресете анимации становиться стразу false, а не после завершения анимации

var languages = ["de", "en", "fr", "it", "ja", "pl", "pt", "ru", "uk", "zh"]

#настройка управления
var expect_input = false
var action = ""
var number_button = 0

func _ready():
	$Animation.play("RESET")
	$Animation.seek(0.2)
	
	update_value_sattings()

func start_animation():
	settings_view = true
	visible = true
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(0.2)

func update_value_sattings():
	#настройки игры
	$Game/Buttons/PhantomFigure2D.button_pressed = G.setting_phantom_figure_2d
	$Game/Buttons2/Theme2D.selected = G.setting_theme_2d
	
	$Game/Buttons3/PhantomFigure3D.button_pressed = G.setting_phantom_figure_3d
	$Game/Buttons4/Theme3D.selected = G.setting_theme_3d
	
	#настройки громкости
	$Volume/Buttons/HBoxContainer/Music.button_pressed = G.setting_music
	$Volume/Buttons/HBoxContainer/SliderMusic.editable = G.setting_music
	$Volume/Buttons/HBoxContainer/SliderMusic.value = G.setting_music_value
	
	$Volume/Buttons/HBoxContainer2/Sounds.button_pressed = G.setting_sounds
	$Volume/Buttons/HBoxContainer2/SliderSounds.editable = G.setting_sounds
	$Volume/Buttons/HBoxContainer2/SliderSounds.value = G.setting_sounds_value
	
	#настройки графики
	$Graphic/Buttons/Fullscreen.button_pressed = G.setting_fullscreen
	$Graphic/Buttons/DisplayFPS.button_pressed = G.setting_display_fps
	$Graphic/Buttons/ShowPauseButton.button_pressed = G.setting_show_pause_button
	$Graphic/Buttons/Animation.button_pressed = G.setting_animation
	$Graphic/Buttons/Particles.button_pressed = G.setting_particles
	
	#настройка языка
	
	var number = 0

	while languages[number] != G.setting_language:
		number += 1

	$Language/ScrollContainer/Control/Buttons.get_child(number).button_pressed = true
	
	#Настройка управления
	
	$Control/ScrollContainer/Control/Actions2D/MoveRight2D.text = str(OS.get_keycode_string(G.setting_control["move_figure_right_2d"]))
	$Control/ScrollContainer/Control/Actions2D/MoveLeft2D.text = str(OS.get_keycode_string(G.setting_control["move_figure_left_2d"]))
	$Control/ScrollContainer/Control/Actions2D/FastMoveDown2D.text = str(OS.get_keycode_string(G.setting_control["fast_move_figure_down_2d"]))
	$Control/ScrollContainer/Control/Actions2D/Descent2D.text = str(OS.get_keycode_string(G.setting_control["drop_figure_2d"]))
	$Control/ScrollContainer/Control/Actions2D/TurnRightZ2D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_right_z_2d"]))
	$Control/ScrollContainer/Control/Actions2D/TurnLeftZ2D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_left_z_2d"]))
	$Control/ScrollContainer/Control/Actions3D/MoveRight3D.text = str(OS.get_keycode_string(G.setting_control["move_figure_right_3d"]))
	$Control/ScrollContainer/Control/Actions3D/MoveLeft3D.text = str(OS.get_keycode_string(G.setting_control["move_figure_left_3d"]))
	$Control/ScrollContainer/Control/Actions3D/MoveForward3D.text = str(OS.get_keycode_string(G.setting_control["move_figure_forward_3d"]))
	$Control/ScrollContainer/Control/Actions3D/MoveBack3D.text = str(OS.get_keycode_string(G.setting_control["move_figure_back_3d"]))
	$Control/ScrollContainer/Control/Actions3D/FastMoveDown3D.text = str(OS.get_keycode_string(G.setting_control["fast_move_figure_down_3d"]))
	$Control/ScrollContainer/Control/Actions3D/Descent3D.text = str(OS.get_keycode_string(G.setting_control["drop_figure_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnRightZ3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_right_z_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnLeftZ3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_left_z_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnRightX3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_right_x_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnLeftX3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_left_x_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnRightY3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_right_y_3d"]))
	$Control/ScrollContainer/Control/Actions3D/TurnLeftY3D.text = str(OS.get_keycode_string(G.setting_control["turn_figure_left_y_3d"]))
	
	$Control/ScrollContainer/Control/Buttons3D2/Sensitivity.value = G.setting_sensitivity


###############
#Выбор настроек
###############

func _on_choice_game_pressed():
	G.sound_button()
	$Choice.visible = false
	$Game.visible = true
	$Game/Animation.play("PLAY")
	if G.setting_animation == false:
		$Game/Animation.seek(0.2)

func _on_choice_volume_pressed():
	G.sound_button()
	$Choice.visible = false
	$Volume.visible = true
	$Volume/Animation.play("PLAY")
	if G.setting_animation == false:
		$Volume/Animation.seek(0.2)

func _on_choice_graphic_pressed():
	G.sound_button()
	$Choice.visible = false
	$Graphic.visible = true
	$Graphic/Animation.play("PLAY")
	if G.setting_animation == false:
		$Graphic/Animation.seek(0.2)

func _on_choice_language_pressed():
	G.sound_button()
	$Choice.visible = false
	$Language.visible = true
	$Language/Animation.play("PLAY")
	if G.setting_animation == false:
		$Language/Animation.seek(0.2)

func _on_choice_control_pressed():
	G.sound_button()
	$Choice.visible = false
	$Control.visible = true
	$Control/Animation.play("PLAY")
	if G.setting_animation == false:
		$Control/Animation.seek(0.2)

func _on_button_back_pressed():
	back()

func back():
	G.sound_button()
	
	$Choice/Animation.play("PLAY")
	if G.setting_animation == false:
		$Choice/Animation.seek(0.2)
	
	if $Control.visible == true:
		$Control/WaitInput.visible = false
		$Control/WaitInput/Animation.play("RESET")
		$Control/WaitInput/Animation.seek(0.2)
	
	$Game.visible = false
	$Volume.visible = false
	$Graphic.visible = false
	$Language.visible = false
	$Control.visible = false
	
	$Choice.visible = true

###############
#Настройки игры
###############

func _on_game_phantom_figure_2d_toggled(button_pressed):
	if G.setting_phantom_figure_2d != button_pressed:
		G.sound_button()
		
		G.setting_phantom_figure_2d = button_pressed
		
		if G.game == true && G.d == "2d":
			get_parent().get_parent().update_setting_phantom_figure_2d()
		
		G.save()

func _on_game_phantom_figure_3d_toggled(button_pressed):
	if G.setting_phantom_figure_3d != button_pressed:
		G.sound_button()
		
		G.setting_phantom_figure_3d = button_pressed
		
		if G.game == true && G.d == "3d":
			get_parent().get_parent().update_setting_phantom_figure_3d()
		
		G.save()

func _on_game_theme_2d_item_selected(index):
	G.sound_button()
	
	G.setting_theme_2d = index
	
	if G.game == true && G.d == "2d":
		get_parent().get_parent().update_map("new_theme")
		get_parent().get_parent().update_background()
	
	G.save()

#################
#Настройки музыки
#################

func _on_game_music_toggled(button_pressed):
	if G.setting_music != button_pressed:
		G.sound_button()
		
		G.setting_music = button_pressed
		
		G.update_music()
		
		$Volume/Buttons/HBoxContainer/SliderMusic.editable = button_pressed
		
		G.save()

func _on_slider_game_music_value_changed(value):
	if G.setting_music_value != value:
		G.setting_music_value = value
		
		G.update_music_value()
		
		G.save()

func _on_slider_game_music_drag_started():
	G.sound_button()

#################
#Настройки звуков
#################

func _on_game_sounds_toggled(button_pressed):
	if G.setting_sounds != button_pressed:
		G.sound_button()
		
		G.setting_sounds = button_pressed
		
		G.sound_button()
		
		$Volume/Buttons/HBoxContainer2/SliderSounds.editable = button_pressed
		
		G.save()

func _on_slider_game_sounds_value_changed(value):
	if G.setting_sounds_value != value:
		G.setting_sounds_value = value
		
		G.update_sounds_value()
		
		G.save()

func _on_slider_game_sounds_drag_started():
	G.sound_button()

##################
#Настройка графики
##################

func _on_graphic_fullscreen_toggled(button_pressed):
	if G.setting_fullscreen != button_pressed:
		G.sound_button()
		
		G.setting_fullscreen = button_pressed
		
		if button_pressed == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif button_pressed == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		G.save()

func _on_graphic_display_fps_toggled(button_pressed):
	if G.setting_display_fps != button_pressed:
		G.sound_button()
		
		G.setting_display_fps = button_pressed
		
		if G.game == true:
			get_parent().get_parent().get_node("FPS").visible = button_pressed
			get_parent().get_parent().get_node("FPS").text = "FPS: " + str(Engine.get_frames_per_second())
		
		G.save()

func _on_show_pause_button_toggled(button_pressed):
	if G.setting_show_pause_button != button_pressed:
		G.sound_button()
		
		G.setting_show_pause_button = button_pressed
		
		if G.game == true:
			get_parent().get_parent().get_node("PauseButton").visible = button_pressed
		
		G.save()

func _on_graphic_animation_toggled(button_pressed):
	if G.setting_animation != button_pressed:
		G.sound_button()
		
		G.setting_animation = button_pressed
		
		G.save()

func _on_graphic_particles_toggled(button_pressed):
	if G.setting_particles != button_pressed:
		G.sound_button()
		
		G.setting_particles = button_pressed
		
		if G.game == false:
			get_parent().get_node("Tetris/Particles").emitting = G.setting_particles
		
		G.save()

func _on_orientation_item_selected(index):
	#ProjectSettings.set_setting("display/window/handheld/orientation", index)
	
	if index == 0:
		ProjectSettings.set_setting("display/window/size/viewport_width", 960)
		ProjectSettings.set_setting("display/window/size/viewport_height", 540)
	elif index == 1:
		ProjectSettings.set_setting("display/window/size/viewport_width", 540)
		ProjectSettings.set_setting("display/window/size/viewport_height", 960)

################
#Настройка языка
################

func _on_language_germany_pressed():
	G.sound_button()
	
	change_language("de")

func _on_language_english_pressed():
	G.sound_button()
	
	change_language("en")

func _on_language_french_pressed():
	G.sound_button()
	
	change_language("fr")

func _on_language_italian_pressed():
	G.sound_button()
	
	change_language("it")

func _on_language_japanese_pressed():
	G.sound_button()
	
	change_language("ja")

func _on_language_polish_pressed():
	G.sound_button()
	
	change_language("pl")

func _on_language_portuguese_pressed():
	G.sound_button()
	
	change_language("pt")

func _on_language_russian_pressed():
	G.sound_button()
	
	change_language("ru")

func _on_language_ukrainian_pressed():
	G.sound_button()
	
	change_language("uk")

func _on_language_chinese_pressed():
	G.sound_button()
	
	change_language("zh")

func change_language(language):
	G.sound_button()
	
	G.setting_language = language
	
	for i in range(len(languages)):
		$Language/ScrollContainer/Control/Buttons.get_child(i).button_pressed = false
	
	var number = 0
	
	while languages[number] != G.setting_language:
		number += 1

	$Language/ScrollContainer/Control/Buttons.get_child(number).button_pressed = true
	
	TranslationServer.set_locale(language)
	
	if G.game == true:
		if G.mode != "classic":
			get_parent().get_parent().update_goal()
	elif G.game == false:
		get_parent().get_node("Levels").update_levels_text()
	
	G.save()

#####################
#Настройки управления
#####################

func _on_control_move_right_2d_replace_pressed():
	action = "move_figure_right_2d"
	number_button = 0
	start_expect_input()

func _on_control_move_left_2d_replace_pressed():
	action = "move_figure_left_2d"
	number_button = 1
	start_expect_input()

func _on_control_fast_move_down_2d_replace_pressed():
	action = "fast_move_figure_down_2d"
	number_button = 2
	start_expect_input()

func _on_control_descent_2d_replace_pressed():
	action = "drop_figure_2d"
	number_button = 3
	start_expect_input()

func _on_control_turn_right_z_2d_replace_pressed():
	action = "turn_figure_right_z_2d"
	number_button = 4
	start_expect_input()

func _on_control_turn_left_z_2d_replace_pressed():
	action = "turn_figure_left_z_2d"
	number_button = 5
	start_expect_input()

func _on_control_move_right_3d_replace_pressed():
	action = "move_figure_right_3d"
	number_button = 0
	start_expect_input()

func _on_control_move_left_3d_replace_pressed():
	action = "move_figure_left_3d"
	number_button = 1
	start_expect_input()

func _on_control_move_forward_3d_replace_pressed():
	action = "move_figure_forward_3d"
	number_button = 2
	start_expect_input()

func _on_control_move_back_3d_replace_pressed():
	action = "move_figure_back_3d"
	number_button = 3
	start_expect_input()

func _on_control_fast_move_down_3d_replace_pressed():
	action = "fast_move_figure_down_3d"
	number_button = 4
	start_expect_input()

func _on_control_descent_3d_replace_pressed():
	action = "drop_figure_3d"
	number_button = 5
	start_expect_input()

func _on_control_turn_right_z_3d_replace_pressed():
	action = "turn_figure_right_z_3d"
	number_button = 6
	start_expect_input()

func _on_control_turn_left_z_3d_replace_pressed():
	action = "turn_figure_left_z_3d"
	number_button = 7
	start_expect_input()

func _on_control_turn_right_x_3d_replace_pressed():
	action = "turn_figure_right_x_3d"
	number_button = 8
	start_expect_input()

func _on_control_turn_left_x_3d_replace_pressed():
	action = "turn_figure_left_x_3d"
	number_button = 9
	start_expect_input()

func _on_control_turn_right_y_3d_replace_pressed():
	action = "turn_figure_right_y_3d"
	number_button = 10
	start_expect_input()

func _on_control_turn_left_y_3d_replace_pressed():
	action = "turn_figure_left_y_3d"
	number_button = 11
	start_expect_input()

func _on_move_camera_up_3d_replace_pressed():
	action = "move_camera_up_3d"
	number_button = 12
	start_expect_input()

func _on_move_camera_down_3d_replace_pressed():
	action = "move_camera_down_3d"
	number_button = 13
	start_expect_input()

func _on_reset_camera_position_3d_replace_pressed():
	action = "reset_camera_position_3d"
	number_button = 14
	start_expect_input()

func start_expect_input():
	$Control/WaitInput.visible = true
	$Control/WaitInput/Animation.play("PLAY")
	if G.setting_animation == false:
		$Control/WaitInput/Animation.seek(0.2)
	
	expect_input = true

func _on_sensitivity_value_changed(value):
	if G.setting_sensitivity != value:
		G.setting_sensitivity = value
		
		if G.game == true:
			get_parent().get_parent().upadate_position_camera()
		
		G.save()

func _on_sensitivity_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			G.scroll = false
		elif event.pressed == false:
			G.scroll = true


##################
#Закрыть настройки
##################

func _on_button_close_pressed():
	if settings_view == true:
		close()

func close():
	settings_view = false
	
	$Animation.play("RESET")
	if G.setting_animation == true:
		await $Animation.animation_finished
	elif G.setting_animation == false:
		$Animation.seek(0.2)
	
	visible = false
	
	back()

#####
#Ввод
#####

func _input(event):
	if expect_input == true:
		if event is InputEventKey:
			$Control/WaitInput.visible = false
			$Control/WaitInput/Animation.play("RESET")
			if G.setting_animation == false:
				$Control/WaitInput/Animation.seek(0.2)
			
			G.setting_control[action] = event.keycode
			
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			
			if action.ends_with("2d"):
				$Control/ScrollContainer/Control/Actions2D.get_child(number_button).text = event.as_text_key_label()
			elif action.ends_with("3d"):
				$Control/ScrollContainer/Control/Actions3D.get_child(number_button).text = event.as_text_key_label()
			
			expect_input = false
			
			G.save()
	
	if event.is_action_pressed("ui_cancel"):
		if settings_view == true:
			close()
