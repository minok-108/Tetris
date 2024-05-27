extends Control

var achivements_view: bool = false #отличается от visible тем, что при ресете анимации становиться стразу false, а не после завершения анимации

func _ready():
	$Animation.play("RESET")
	$Animation.seek(0.2)

func start_animation():
	achivements_view = true
	visible = true
	
	$Animation.play("PLAY")
	if G.setting_animation == false:
		$Animation.seek(0.2)

func update_value_achievements():
	var number_achievement: String
	for i in range(len(G.completed_achievements)):
		if i != 0:
			number_achievement = str(i + 1)
		
		get_node("ScrollContainer/Control/VBoxContainer/Achievement" + number_achievement + "/AchievementCompleted").visible = G.completed_achievements[i]

func _on_button_close_pressed():
	if achivements_view == true:
		G.sound_button()
		
		close()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if achivements_view == true:
			G.sound_button()
			
			close()

func close():
	achivements_view = false
	
	$Animation.play("RESET")
	if G.setting_animation == true:
		await $Animation.animation_finished
	elif G.setting_animation == false:
		$Animation.seek(0.2)
	
	visible = false
