extends Control

var levels_view: bool = false #отличается от visible тем, что при ресете анимации становиться стразу false, а не после завершения анимации

func _ready():
	update_levels_text()
	update_completed_levels()

func start_animation():
	levels_view = true
	visible = true
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(0.2)

func update_levels_text():
	for i in range(24):
		var number_container = ""
		if i >= 2:
			number_container = str(int(i / 2.0) + 1)
		if i < 12:
			get_node("ScrollContainer/Control/Buttons/HBoxContainer" + number_container + "/" + str(i + 1) + "Level").text = str(i + 1) + " " + tr("$level")
		elif i >= 12:
			get_node("ScrollContainer/Control/Buttons/HBoxContainer" + number_container + "/" + str(i - 11) + "Level").text = str(i - 11) + " " + tr("$level")


func update_completed_levels():
	for i in range(12):
		var number_container = ""
		if i >= 2:
			number_container = str(int(i / 2.0) + 1)
		get_node("ScrollContainer/Control/Buttons/HBoxContainer" + number_container + "/" + str(i + 1) + "Level/LabelCompleted").visible = G.completed_levels_2d[i]

func _on_2d_1_level_pressed():
	G.sound_button()
	
	G.mode = "1_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_2_level_pressed():
	G.sound_button()
	
	G.mode = "2_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_3_level_pressed():
	G.sound_button()
	
	G.mode = "3_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_4_level_pressed():
	G.sound_button()
	
	G.mode = "4_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_5_level_pressed():
	G.sound_button()
	
	G.mode = "5_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_6_level_pressed():
	G.mode = "6_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_7_level_pressed():
	G.mode = "7_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_8_level_pressed():
	G.mode = "8_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_9_level_pressed():
	G.mode = "9_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_10_level_pressed():
	G.mode = "10_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_11_level_pressed():
	G.mode = "11_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_2d_12_level_pressed():
	G.mode = "12_level"
	G.d = "2d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_1_level_pressed():
	G.mode = "1_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_2_level_pressed():
	G.mode = "2_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_3_level_pressed():
	G.mode = "3_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_4_level_pressed():
	G.mode = "4_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_5_level_pressed():
	G.mode = "5_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_6_level_pressed():
	G.mode = "6_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_7_level_pressed():
	G.mode = "7_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_8_level_pressed():
	G.mode = "8_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_9_level_pressed():
	G.mode = "9_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_10_level_pressed():
	G.mode = "10_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_11_level_pressed():
	G.mode = "11_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_3d_12_level_pressed():
	G.mode = "12_level"
	G.d = "3d"
	get_tree().change_scene_to_file("res://nodes/Game.tscn")

func _on_button_close_pressed():
	if levels_view == true:
		G.sound_button()
		
		close()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if levels_view == true:
			G.sound_button()
			
			close()

func close():
	levels_view = false
	
	$Animation.play("RESET")
	if G.setting_animation == true:
		await $Animation.animation_finished
	elif G.setting_animation == false:
		$Animation.seek(0.2)
	
	visible = false
