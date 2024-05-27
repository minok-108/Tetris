extends Node

var game = false

var d = "" #2d or 3d

var mode = ""

#Цвет фона, чтобы при исчезнавении слоя подставить цвет фона
var background_color: Color

var scroll: bool = true

var best_score_2d: int = 0
var games_played_2d: int = 0
var games_won_2d: int = 0
var games_lost_2d: int = 0
var broken_layers_2d: int = 0

var best_score_3d: int = 0
var games_played_3d: int = 0
var games_won_3d: int = 0
var games_lost_3d: int = 0
var broken_layers_3d: int = 0

var completed_levels_2d: Array = [false, false, false, false, false, false, false, false, false, false, false, false]
var completed_levels_3d: Array = [false, false, false, false, false, false, false, false, false, false, false, false]

var completed_achievements: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

#настройки игры
var setting_phantom_figure_2d: bool = true
var setting_theme_2d: int = 0

var setting_phantom_figure_3d: bool = true
var setting_theme_3d: int = 0

#основные настройки
var setting_music: bool = true
var setting_music_value: int = 100
var setting_sounds: bool = true
var setting_sounds_value: int = 100

#настройки графики
var setting_fullscreen: bool = false
var setting_display_fps: bool = false
var setting_show_pause_button: bool = true
var setting_animation: bool = true
var setting_particles: bool = true
var setting_orientation: String = "landscape"

#Настройки языка
var setting_language: String = OS.get_locale().substr(0, 2)

#Настройки управления
var setting_control: Dictionary = {
	"move_figure_right_2d": 4194321,
	"move_figure_left_2d": 4194319,
	"fast_move_figure_down_2d": 4194322,
	"drop_figure_2d": 32,
	"turn_figure_right_z_2d": 4194320,
	"turn_figure_left_z_2d": 90,
	"move_figure_right_3d": 4194321,
	"move_figure_left_3d": 4194319,
	"move_figure_forward_3d": 4194320,
	"move_figure_back_3d": 4194322,
	"fast_move_figure_down_3d": 4194325,
	"drop_figure_3d": 32,
	"turn_figure_right_z_3d": 65,
	"turn_figure_left_z_3d": 90,
	"turn_figure_right_x_3d": 83,
	"turn_figure_left_x_3d": 88,
	"turn_figure_right_y_3d": 68,
	"turn_figure_left_y_3d": 67,
	
	"move_camera_up_3d": 91,
	"move_camera_down_3d": 93,
	"reset_camera_position_3d": 82
}

var setting_sensitivity: float = 1

var save_text = {
	#информация
	"best_score_2d": best_score_2d,
	"games_played_2d": games_played_2d,
	"games_won_2d": games_won_2d,
	"games_lost_2d": games_lost_2d,
	"broken_layers_2d": broken_layers_2d,
	
	"best_score_3d": best_score_3d,
	"games_played_3d": games_played_3d,
	"games_won_3d": games_won_3d,
	"games_lost_3d": games_lost_3d,
	"broken_layers_3d": broken_layers_3d,
	
	"completed_levels_3d": completed_levels_2d,
	"completed_levels_2d": completed_levels_3d,
	
	"completed_achievements": completed_achievements,
	
	#Настройки игры
	"setting_phantom_figure_2d": setting_phantom_figure_2d,
	"setting_theme_2d": setting_theme_2d,
	
	"setting_phantom_figure_3d": setting_phantom_figure_3d,
	"setting_theme_3d": setting_theme_3d,
	
	#настройки громкости
	"setting_music": setting_music,
	"setting_music_value": setting_music_value,
	"setting_sounds": setting_sounds,
	"setting_sounds_value": setting_sounds_value,
	
	#настройки графики
	"setting_fullscreen": setting_fullscreen,
	"setting_display_fps": setting_display_fps,
	"setting_show_pause_button": setting_show_pause_button,
	"setting_animation": setting_animation,
	"setting_particles": setting_particles,
	"setting_orientation": setting_orientation,
	
	#настройки языка
	"setting_language": setting_language,
	
	#Настройки управления
	"setting_control": setting_control,
	
	"setting_sensitivity": setting_sensitivity
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	loadd()

func loadd():
	#проверка на существование файла
	if FileAccess.file_exists("user://file.json") == false:
		save()
	
	#открытие предыдущего сохраниеия
	var file = FileAccess.open("user://file.json", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	save_text = test_json_conv.get_data()
	
	#информация
	best_score_2d = int(save_text.best_score_2d)
	games_played_2d = int(save_text.games_played_2d)
	games_won_2d = int(save_text.games_won_2d)
	games_lost_2d = int(save_text.games_lost_2d)
	broken_layers_2d = int(save_text.broken_layers_2d)
	
	best_score_3d = int(save_text.best_score_3d)
	games_played_3d = int(save_text.games_played_3d)
	games_won_3d = int(save_text.games_won_3d)
	games_lost_3d = int(save_text.games_lost_3d)
	broken_layers_3d = int(save_text.broken_layers_3d)
	
	completed_levels_2d = Array(save_text.completed_levels_2d)
	completed_levels_3d = Array(save_text.completed_levels_3d)
	
	completed_achievements = Array(save_text.completed_achievements)
	
	#настройки игры
	setting_phantom_figure_2d = bool(save_text.setting_phantom_figure_2d)
	setting_phantom_figure_3d = bool(save_text.setting_phantom_figure_3d)
	
	setting_theme_2d =  int(save_text.setting_theme_2d)
	setting_theme_3d =  int(save_text.setting_theme_3d)
	
	
	#настройки громкости
	setting_music = bool(save_text.setting_music)
	setting_music_value = int(save_text.setting_music_value)
	
	setting_sounds = bool(save_text.setting_sounds)
	setting_sounds_value = int(save_text.setting_sounds_value)
	
	#настройки графики
	setting_fullscreen = bool(save_text.setting_fullscreen)
	setting_display_fps = bool(save_text.setting_display_fps)
	setting_show_pause_button = bool(save_text.setting_show_pause_button)
	setting_animation = bool(save_text.setting_animation)
	setting_particles = bool(save_text.setting_particles)
	setting_orientation = str(save_text.setting_orientation)
	
	#настройки языкак
	setting_language = str(save_text.setting_language)
	
	#Настройки управления
	setting_control = Dictionary(save_text.setting_control)
	setting_sensitivity = float(save_text.setting_sensitivity)
	
	update_settings()

func update_settings():
	#настройки звука
	update_music_value()
	update_sounds_value()
	
	update_music()
	
	#настройки графики
	if setting_fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif setting_fullscreen == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	#настройки языкак
	TranslationServer.set_locale(setting_language)
	
	#Настройки управления
	for i in InputMap.get_actions():
		if i.ends_with("2d") || i.ends_with("3d"):
			var ev = InputEventKey.new()
			
			ev.keycode = setting_control[i]
			InputMap.action_erase_events(i)
			InputMap.action_add_event(i, ev)

func save():
	save_text = {
		#информация
		"best_score_2d": best_score_2d,
		"games_played_2d": games_played_2d,
		"games_won_2d": games_won_2d,
		"games_lost_2d": games_lost_2d,
		"broken_layers_2d": broken_layers_2d,
		
		"best_score_3d": best_score_3d,
		"games_played_3d": games_played_3d,
		"games_won_3d": games_won_3d,
		"games_lost_3d": games_lost_3d,
		"broken_layers_3d": broken_layers_3d,
		
		"completed_levels_2d": completed_levels_2d,
		"completed_levels_3d": completed_levels_3d,
		
		"completed_achievements": completed_achievements,
		
		#Настройки игры
		"setting_phantom_figure_2d": setting_phantom_figure_2d,
		"setting_theme_2d": setting_theme_2d,
		
		"setting_phantom_figure_3d": setting_phantom_figure_3d,
		"setting_theme_3d": setting_theme_3d,
		
		#настройки громкости
		"setting_music": setting_music,
		"setting_music_value": setting_music_value,
		"setting_sounds": setting_sounds,
		"setting_sounds_value": setting_sounds_value,
		
		#настройки графики
		"setting_fullscreen": setting_fullscreen,
		"setting_display_fps": setting_display_fps,
		"setting_show_pause_button": setting_show_pause_button,
		"setting_animation": setting_animation,
		"setting_particles": setting_particles,
		"setting_orientation": setting_orientation,
		
		#настройки языка
		"setting_language": setting_language,
		
		#Настройки управления
		"setting_control": setting_control,
		
		"setting_sensitivity": setting_sensitivity
	}
	
	var file = FileAccess.open("user://file.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_text))

#################################
#Выполнена ли какая-нибудь ачивка
#################################

func is_achievement_completed(category: String) -> void:
	if category == "game_played":
		if games_played_2d == 200:
			if completed_achievements[0] != true:
				completed_achievements[0] = true
		
		elif games_played_2d == 3000:
			if completed_achievements[1] != true:
				completed_achievements[1] = true
		
		elif games_played_3d == 100:
			if completed_achievements[2] != true:
				completed_achievements[2] = true
		
		elif games_played_3d == 2000:
			if completed_achievements[3] != true:
				completed_achievements[3] = true
	
	elif category == "layers":
		if broken_layers_2d >= 1000000:
			if completed_achievements[6] != true:
				completed_achievements[6] = true
		
		elif broken_layers_2d >= 2000:
			if completed_achievements[5] != true:
				completed_achievements[5] = true
		
		elif broken_layers_2d >= 400:
			if completed_achievements[4] != true:
				completed_achievements[4] = true
		
		if broken_layers_3d >= 200:
			if completed_achievements[9] != true:
				completed_achievements[9] = true
		
		elif broken_layers_3d >= 30:
			if completed_achievements[8] != true:
				completed_achievements[8] = true
		
		elif broken_layers_3d >= 1:
			if completed_achievements[7] != true:
				completed_achievements[7] = true
	
	elif category == "score":
		if best_score_2d >= 50000:
			if completed_achievements[14] != true:
				completed_achievements[14] = true
		
		elif best_score_2d >= 40000:
			if completed_achievements[13] != true:
				completed_achievements[13] = true
		
		elif best_score_2d >= 30000:
			if completed_achievements[12] != true:
				completed_achievements[12] = true
		
		elif best_score_2d >= 20000:
			if completed_achievements[11] != true:
				completed_achievements[11] = true
		
		elif best_score_2d >= 4000:
			if completed_achievements[10] != true:
				completed_achievements[10] = true
		
		if best_score_3d >= 50000:
			if completed_achievements[19] != true:
				completed_achievements[19] = true
		
		elif best_score_3d >= 40000:
			if completed_achievements[18] != true:
				completed_achievements[18] = true
		
		elif best_score_3d >= 30000:
			if completed_achievements[17] != true:
				completed_achievements[17] = true
		
		elif best_score_3d >= 20000:
			if completed_achievements[16] != true:
				completed_achievements[16] = true
		
		elif best_score_3d >= 4000:
			if completed_achievements[15] != true:
				completed_achievements[15] = true
	
	elif category == "levels":
		if completed_achievements[20] != true:
			if false in completed_levels_2d:
				pass
			else:
				completed_achievements[20] = true
		
		if completed_achievements[21] != true:
			if false in completed_levels_3d:
				pass
			else:
				completed_achievements[21] = true
		
		if completed_achievements[22] != true:
			if completed_achievements[20] == true && completed_achievements[21] == true:
				completed_achievements[22] = true

###########
#Обновления
###########

func update_music():
	if setting_music == true:
		$Music.play()
	elif setting_music == false:
		$Music.stop()

func update_music_value():
	$Music.volume_db = setting_music_value * 0.8 - 80

func sound_button():
	if setting_sounds == true:
		$SoundButton.play()

func update_sounds_value():
	$SoundButton.volume_db = setting_sounds_value * (0.8) - 80
