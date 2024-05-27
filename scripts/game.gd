extends Control

var s_layer_2d = load("res://nodes/Layer.tscn")

var default_spawn_figure_tiles_2d: Array = [
	[Vector2i(5, 1), Vector2i(6, 1), Vector2i(5, 2), Vector2i(6, 2)],
	[Vector2i(5, 1), Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2)],
	[Vector2i(4, 1), Vector2i(5, 1), Vector2i(6, 1), Vector2i(7, 1)],
	[Vector2i(6, 1), Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2)],
	[Vector2i(4, 1), Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2)],
	[Vector2i(5, 1), Vector2i(6, 1), Vector2i(4, 2), Vector2i(5, 2)],
	[Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 2), Vector2i(6, 2)]
]

var default_spawn_figure_tiles_3d: Array = [
	[Vector3i(2, 20, 2), Vector3i(2, 20, 3), Vector3i(3, 20, 2), Vector3i(3, 20, 3)],
	[Vector3i(2, 20, 2), Vector3i(1, 20, 3), Vector3i(2, 20, 3), Vector3i(3, 20, 3)],
	[Vector3i(1, 20, 2), Vector3i(2, 20, 2), Vector3i(3, 20, 2), Vector3i(4, 20, 2)],
	[Vector3i(3, 20, 2), Vector3i(1, 20, 3), Vector3i(2, 20, 3), Vector3i(3, 20, 3)],
	[Vector3i(1, 20, 2), Vector3i(1, 20, 3), Vector3i(2, 20, 2), Vector3i(3, 20, 2)],
	[Vector3i(2, 20, 2), Vector3i(3, 20, 2), Vector3i(1, 20, 3), Vector3i(2, 20, 3)],
	[Vector3i(1, 20, 2), Vector3i(2, 20, 2), Vector3i(2, 20, 3), Vector3i(3, 20, 3)]
]

var now_figure_tiles: Array = []
var future_figure_tiles: Array = []

var score: int = 0
var layers: int = 0
var speed: int = 1

var size_map_3d: int = 4

var type: int = randi_range(0, 6)
var temporary_figure: int = randi_range(0, 6)

#Слои ломаются за определенное время, в это время эта переменная равна true
var layers_break_now: bool = false

var interval_shift: bool = true

#При появлении новой фигуры
var new_figure: bool = true

#Для быстрого спуска
var fast_descent: bool = false

#Для телефонного управления
var phone_button_down: bool = false
var phone_button_right: bool = false
var phone_button_left: bool = false

var alpha_camera_3d: float = 1
var beta_camera_3d: float = 1

var radius_camera_3d: float = 30
var k_radius_camera_3d: float = 30

var camera_height: float = 0

func _ready() -> void:
	randomize()
	
	start()

func start() -> void:
	var s_game
	
	if G.d == "2d":
		s_game = load("res://nodes/2D.tscn")
	elif G.d == "3d":
		s_game = load("res://nodes/3D.tscn")

	var game = s_game.instantiate()

	add_child(game)
	move_child(game, 4)
	
	#Обновить настройки
	$FPS.visible = G.setting_display_fps
	$PauseButton.visible = G.setting_show_pause_button
	
	new_game()

###################
#Спавн новой фигуры
###################

func spawn() -> void:
	start_timers()
	var next_type: int = randi_range(0, 6)
	
	replacement(next_type)
	
	if G.d == "2d":
		now_figure_tiles = default_spawn_figure_tiles_2d[type].duplicate(true)
	elif G.d == "3d":
		now_figure_tiles = default_spawn_figure_tiles_3d[type].duplicate(true)
		
		var additional_bias: int
		
		if size_map_3d > 4:
			additional_bias = int((size_map_3d - 4) / 2.0)
			for i in range(4):
				now_figure_tiles[i].x += additional_bias
				now_figure_tiles[i].z += additional_bias
	
	future_figure_tiles = now_figure_tiles.duplicate(true)
	
	change_figure("spawn")

#########################################
#Заменить фигуру (из следующей в текущую)
#########################################

func replacement(next_type: int) -> void:
	$Info/NextFigureMap.clear()
	type = temporary_figure
	temporary_figure = next_type
	
	var next_figure_tiles: Array = default_spawn_figure_tiles_2d[next_type].duplicate(true)
	
	if next_type == 0:
		$Info/NextFigureMap.position.x = -16 * (540.0 / 704.0)
		$Info/NextFigureMap.position.y = 0
	elif next_type == 2:
		$Info/NextFigureMap.position.x = -16 * (540.0 / 704.0)
		$Info/NextFigureMap.position.y = 16 * (540.0 / 704.0)
	else:
		$Info/NextFigureMap.position.x = 0
		$Info/NextFigureMap.position.y = 0
	
	for i in range(4):
		next_figure_tiles[i].x -= 3
		next_figure_tiles[i].y += 10
		
		if G.d == "2d":
			$Info/NextFigureMap.set_cell(0, next_figure_tiles[i], G.setting_theme_2d, choice_grid_tile(next_type))
		elif G.d == "3d":
			$Info/NextFigureMap.set_cell(0, next_figure_tiles[i], 0, choice_grid_tile(next_type))

########################################
#Переместить фигуру в будущих координтах
########################################

func move_figure(action: String) -> void:
	if action == "down":
		for i in range(4):
			if G.d == "2d":
				future_figure_tiles[i].y += 1
			elif G.d == "3d":
				future_figure_tiles[i].y -= 1
	
	elif action == "right":
		for i in range(4):
			future_figure_tiles[i].x += 1
	
	elif action == "left":
		for i in range(4):
			future_figure_tiles[i].x -= 1
	
	elif action == "forward": 
		for i in range(4):
			future_figure_tiles[i].z -= 1
	
	elif action == "back":
		for i in range(4):
			future_figure_tiles[i].z += 1
	
	change_figure(action)

#######################################
#Повернуть фигуру в будущих координатах
#######################################

func turn_figure(plane: String, side: String) -> void:
	if G.d == "2d" && type == 0:
		return
	
	var save_future_figure_tiles_1: Array = []
	var save_future_figure_tiles_2: Array = []
	
	var save_now_figure_tiles_1: Array = []
	var save_now_figure_tiles_2: Array = []
	
	var center_figure_tiles_1: int
	var center_figure_tiles_2: int
	
	var factor_side: int
	
	if side == "right":
		factor_side = 1
	elif side == "left":
		factor_side = -1
	
	var center: int = get_figure_center()
	
	if plane == "x":
		if G.d == "3d":
			var is_turning = false
			if type == 0:
				for i in range(4):
					if now_figure_tiles[i].x != now_figure_tiles[0].x:
						is_turning = true
				
				if is_turning == false:
					return
				
		for i in range(4):
			save_future_figure_tiles_1.append(future_figure_tiles[i].z)
			save_future_figure_tiles_2.append(future_figure_tiles[i].y)
			save_now_figure_tiles_1.append(now_figure_tiles[i].z)
			save_now_figure_tiles_2.append(now_figure_tiles[i].y)
		
		center_figure_tiles_1 = now_figure_tiles[center].z
		center_figure_tiles_2 = now_figure_tiles[center].y
	
	elif plane == "y":
		if G.d == "3d":
			var is_turning = false
			if type == 0:
				for i in range(4):
					if now_figure_tiles[i].y != now_figure_tiles[0].y:
						is_turning = true
				
				if is_turning == false:
					return
		
		for i in range(4):
			save_future_figure_tiles_1.append(future_figure_tiles[i].x)
			save_future_figure_tiles_2.append(future_figure_tiles[i].z)
			save_now_figure_tiles_1.append(now_figure_tiles[i].x)
			save_now_figure_tiles_2.append(now_figure_tiles[i].z)
		
		center_figure_tiles_1 = now_figure_tiles[center].x
		center_figure_tiles_2 = now_figure_tiles[center].z
	
	elif plane == "z":
		if G.d == "3d":
			var is_turning = false
			if type == 0:
				for i in range(4):
					if now_figure_tiles[i].z != now_figure_tiles[0].z:
						is_turning = true
				
				if is_turning == false:
					return
		
		for i in range(4):
			save_future_figure_tiles_1.append(future_figure_tiles[i].x)
			save_future_figure_tiles_2.append(future_figure_tiles[i].y)
			save_now_figure_tiles_1.append(now_figure_tiles[i].x)
			save_now_figure_tiles_2.append(now_figure_tiles[i].y)
		
		center_figure_tiles_1 = now_figure_tiles[center].x
		center_figure_tiles_2 = now_figure_tiles[center].y
	
	for i in range(4):
		
		var delta_1: int = save_now_figure_tiles_1[i] - center_figure_tiles_1
		var delta_2: int = save_now_figure_tiles_2[i] - center_figure_tiles_2
		
		if delta_1 < 0:
			save_future_figure_tiles_2[i] = -abs(delta_1) * factor_side + center_figure_tiles_2
			if delta_2 == 0:
				save_future_figure_tiles_1[i] = center_figure_tiles_1
		
		if delta_1 > 0:
			save_future_figure_tiles_2[i] = abs(delta_1) * factor_side + center_figure_tiles_2
			if delta_2 == 0:
				save_future_figure_tiles_1[i] = center_figure_tiles_1
		
		if delta_2 < 0:
			save_future_figure_tiles_1[i] = abs(delta_2) * factor_side + center_figure_tiles_1
			if delta_1 == 0:
				save_future_figure_tiles_2[i] = center_figure_tiles_2
		
		if delta_2 > 0:
			save_future_figure_tiles_1[i] = -abs(delta_2) * factor_side + center_figure_tiles_1
			if delta_1 == 0:
				save_future_figure_tiles_2[i] = center_figure_tiles_2
	
	if plane == "x":
		for i in range(4):
			future_figure_tiles[i].z = save_future_figure_tiles_1[i]
			future_figure_tiles[i].y = save_future_figure_tiles_2[i]
	elif plane == "y":
		for i in range(4):
			future_figure_tiles[i].x = save_future_figure_tiles_1[i]
			future_figure_tiles[i].z = save_future_figure_tiles_2[i]
	elif plane == "z":
		for i in range(4):
			future_figure_tiles[i].x = save_future_figure_tiles_1[i]
			future_figure_tiles[i].y = save_future_figure_tiles_2[i]
	
	change_figure("turn_" + plane)

###########################################################
#Перемещение или поворот фигуры исходя из будущих координат
###########################################################

func change_figure(action: String) -> void:
	var is_change: bool = true
	if other_tiles(future_figure_tiles) == true:
		if action == "down":
			new_figure = true
			
			now_figure_tiles = [] #Чтобы тайлы в смертельной зоне не считались падающей фигурой
			
			await check_layers()
			
			is_level_ending()
			
			if G.game == true:
				spawn()
			elif G.game == false:
				return
		
		is_change = false
		
		if action == "turn_x" || action == "turn_y" || action == "turn_z":
			is_change = is_bias_figure(action)
	
	if is_change == true:
		for j in range(4):
			remove_main_cell(now_figure_tiles[j])
		
		now_figure_tiles = future_figure_tiles.duplicate(true)
		
		for j in range(4):
			set_main_cell(now_figure_tiles[j])
		
		is_level_ending()
		
	else:
		future_figure_tiles = now_figure_tiles.duplicate(true)
	
	if action != "down":
		change_phantom_figure()

############################################
#Смещение фигуры, если она уперслась в стену
############################################

func is_bias_figure(action: String) -> bool:
	var save_future_figure_tiles: Array = future_figure_tiles.duplicate(true)
	
	for j in range(4):
		future_figure_tiles[j].x += 1
		
	if other_tiles(future_figure_tiles) == false:
		return true
	else:
		if type == 2:
			if action != "turn_x":
				for j in range(4):
					future_figure_tiles[j].x += 1
				if other_tiles(future_figure_tiles) == false:
					return true
	
	future_figure_tiles = save_future_figure_tiles.duplicate(true)
	
	for j in range(4):
		future_figure_tiles[j].x -= 1
		
	if other_tiles(future_figure_tiles) == false:
		return true
	else:
		if type == 2:
			if action != "turn_x":
				for j in range(4):
					future_figure_tiles[j].x -= 1
				if other_tiles(future_figure_tiles) == false:
					return true
	
	future_figure_tiles = save_future_figure_tiles.duplicate(true)
	
	if G.d == "2d":
		for j in range(4):
			future_figure_tiles[j].y += 1
			
		if other_tiles(future_figure_tiles) == false:
			return true
		else:
			if type == 2:
				for j in range(4):
					future_figure_tiles[j].y += 1
				if other_tiles(future_figure_tiles) == false:
					return true
	
	elif G.d == "3d":
		future_figure_tiles = save_future_figure_tiles.duplicate(true)
		
		for j in range(4):
			future_figure_tiles[j].z += 1
			
		if other_tiles(future_figure_tiles) == false:
			return true
		else:
			if type == 2:
				if action != "turn_z":
					for j in range(4):
						future_figure_tiles[j].z += 1
					if other_tiles(future_figure_tiles) == false:
						return true
		
		future_figure_tiles = save_future_figure_tiles.duplicate(true)
		
		for j in range(4):
			future_figure_tiles[j].z -= 1
			
		if other_tiles(future_figure_tiles) == false:
			return true
		else:
			if type == 2:
				if action != "turn_z":
					for j in range(4):
						future_figure_tiles[j].z -= 1
					if other_tiles(future_figure_tiles) == false:
						return true
	
	return false

##################################################
#Отображение фантомной фигуры под основной фигурой
##################################################

func change_phantom_figure() -> void:
	if G.game == true:
		var view: bool = false
		
		if G.d == "2d" && G.setting_phantom_figure_2d == true:
			view = true
		elif G.d == "3d" && G.setting_phantom_figure_3d == true:
			view = true
		
		if view == true:
			$D/PhantomMap.clear()
			
			var future_figure_phantom_tiles: Array = now_figure_tiles.duplicate(true)
			
			if future_figure_phantom_tiles:
				while true:
					for i in range(4):
						if G.d == "2d":
							future_figure_phantom_tiles[i].y += 1
						elif G.d == "3d":
							future_figure_phantom_tiles[i].y -= 1
					
					if other_tiles(future_figure_phantom_tiles) == true:
						for j in range(4):
							if G.d == "2d":
								set_phantom_cell(Vector2(future_figure_phantom_tiles[j].x, future_figure_phantom_tiles[j].y - 1))
							elif G.d == "3d":
								set_phantom_cell(Vector3(future_figure_phantom_tiles[j].x, future_figure_phantom_tiles[j].y + 1, future_figure_phantom_tiles[j].z))
						break

#####################################################
#Проверять слои (сломался ли слой, проиграл ли игрок)
#####################################################

func check_layers() -> void:
	#проверка дыух верхних слоев на проигыш
	if G.d == "2d":
		for i in range(10):
			for j in range(2):
				if $D/MainMap.get_cell_source_id(0, Vector2i(i + 1, j + 1)) != -1:
					if Vector2i(i + 1, j + 1) in now_figure_tiles:
						pass
					else:
						$WinOrLose.game_over("lose")
						return
	
	elif G.d == "3d":
		for i in range(size_map_3d):
			for j in range(2):
				for k in range(size_map_3d):
					if $D/MainMap.get_cell_item(Vector3i(i + 1, j + 19, k + 1)) != -1:
						if Vector3i(i + 1, j + 19, k + 1) in now_figure_tiles:
							pass
						else:
							$WinOrLose.game_over("lose")
							return
	
	#Проверка на ломание готовых слоев
	var amount_layer = 0
	var layers_to_remove = []
	
	if G.d == "2d":
		for j in range(20):
			var break_layer: bool = true
			for i in range(10):
				if $D/MainMap.get_cell_atlas_coords(0, Vector2i(i + 1, j + 1)) == Vector2i(0, 2):
					break_layer = false
				if $D/MainMap.get_cell_source_id(0, Vector2i(i + 1, j + 1)) == -1:
					break_layer = false
				
			if break_layer == true:
				layers_to_remove.append(j)
				amount_layer += 1
		
		await braek_layer(layers_to_remove)
	
	elif G.d == "3d":
		for y in range(20, -1, -1):
			var break_layer: bool = true
			for x in range(size_map_3d):
				for z in range(size_map_3d):
					if $D/MainMap.get_cell_item(Vector3i(x + 1, y + 1, z + 1)) == -1:
						break_layer = false
				
			if break_layer == true:
				amount_layer += 1
				for ii in range(size_map_3d):
					for kk in range(size_map_3d):
						$D/MainMap.set_cell_item(Vector3i(ii + 1, y + 1, kk + 1), -1)
				
				for l in range(20 - y):
					for ii in range(size_map_3d):
						for kk in range(size_map_3d):
							remove_main_cell(Vector3i(ii + 1, y + l + 1, kk + 1))
							type =  $D/MainMap.get_cell_item(Vector3i(ii + 1, y + l + 2, kk + 1))
							set_main_cell(Vector3i(ii + 1, y + l + 1, kk + 1))
	
	layers += amount_layer
	
	if G.d == "2d":
		G.broken_layers_2d += amount_layer
	elif G.d == "3d":
		G.broken_layers_3d += amount_layer
	
	G.is_achievement_completed("layers")
	
	G.save()
	
	if G.mode == "classic":
		if speed != 13:
			speed = int(layers /  10.0) + 1
		
		update_teak()
		
		if amount_layer == 1:
			score += 100
		elif amount_layer == 2:
			score += 300
		elif amount_layer == 3:
			score += 700
		elif amount_layer == 4:
			var tetris = load("res://nodes/Tetris.tscn").instantiate()
			add_child(tetris)
			
			score += 1500
	
	update_info()

func braek_layer(delite_layers: Array) -> void:
	layers_break_now = true
	
	if len(delite_layers) != 0:
		if G.setting_particles == true:
			for j in delite_layers:
				var layer = s_layer_2d.instantiate()
				$D/MainMap.add_child(layer)
				layer.position = Vector2(32, (j + 1) * 32) 
		
		stop_timers()
		await get_tree().create_timer(0.2).timeout
		
		for j in delite_layers:
			for i in range(10):
				$D/MainMap.set_cell(0, Vector2i(i + 1, j + 1) , -1, Vector2i(0, 0))
			
			for i in range(j - 1):
				for k in range(10):
					$D/MainMap.set_cell(0, Vector2i(k + 1, j - i + 1) , G.setting_theme_2d, $D/MainMap.get_cell_atlas_coords(0, Vector2i(k + 1, j - i)))
	
	layers_break_now = false

#########################
#Заканчивается ли уровень
#########################

func is_level_ending() -> void:
	var win: bool = false
	
	if G.d == "2d":
		if G.mode == "1_level":
			if layers >= 3:
				G.completed_levels_2d[0] = true
				win = true
			
		elif G.mode == "2_level":
			for i in range(4):
				if now_figure_tiles[i].y == 20:
					G.completed_levels_2d[1] = true
					win = true
		
		elif G.mode == "3_level":
			for i in range(4):
				if now_figure_tiles[i].y == 20:
					G.completed_levels_2d[2] = true
					win = true
		
		elif G.mode == "4_level":
			if layers >= 9:
				G.completed_levels_2d[3] = true
				win = true
		
		elif G.mode == "5_level":
			for i in range(4):
				if now_figure_tiles[i].y == 20:
					G.completed_levels_2d[4] = true
					win = true
		
		elif G.mode == "6_level":
			if layers >= 7:
				G.completed_levels_2d[6] = true
				win = true
			
		elif G.mode == "7_level":
			if layers >= 9:
				G.completed_levels_2d[6] = true
				win = true
		
		elif G.mode == "8_level":
			if layers >= 13:
				G.completed_levels_2d[7] = true
				win = true
		
		elif G.mode == "9_level":
			if layers >= 13:
				G.completed_levels_2d[8] = true
				win = true
		
		elif G.mode == "10_level":
			if layers >= 13:
				G.completed_levels_2d[9] = true
				win = true
		
		elif G.mode == "11_level":
			if layers >= 15:
				G.completed_levels_2d[10] = true
				win = true
		
		elif G.mode == "12_level":
			if layers >= 15:
				G.completed_levels_2d[11] = true
				win = true
	
	elif G.d == "3d":
		if G.mode == "1_level":
			if layers >= 3:
				G.completed_levels_2d[0] = true
				win = true
			
		elif G.mode == "2_level":
			for i in range(4):
				if now_figure_tiles[i].y == 1:
					G.completed_levels_2d[1] = true
					win = true
		
		elif G.mode == "3_level":
			for i in range(4):
				if now_figure_tiles[i].y == 1:
					G.completed_levels_2d[2] = true
					win = true
		
		elif G.mode == "4_level":
			for i in range(4):
				if now_figure_tiles[i].y == 1:
					G.completed_levels_2d[3] = true
					win = true
		
		elif G.mode == "5_level":
			for i in range(4):
				if now_figure_tiles[i].y == 1:
					G.completed_levels_2d[4] = true
					win = true
		
		elif G.mode == "6_level":
			if layers >= 7:
				G.completed_levels_2d[5] = true
				win = true
			
		elif G.mode == "7_level":
			if layers >= 9:
				G.completed_levels_2d[6] = true
				win = true
		
		elif G.mode == "8_level":
			for i in range(4):
				if now_figure_tiles[i].y == 1:
					G.completed_levels_2d[7] = true
					win = true
		
		elif G.mode == "9_level":
			if layers >= 13:
				G.completed_levels_2d[8] = true
				win = true
		
		elif G.mode == "10_level":
			if layers >= 13:
				G.completed_levels_2d[9] = true
				win = true
		
		elif G.mode == "11_level":
			if layers >= 15:
				G.completed_levels_2d[10] = true
				win = true
		
		elif G.mode == "12_level":
			if layers >= 15:
				G.completed_levels_2d[11] = true
				win = true
	
	if win == true:
		G.is_achievement_completed("levels")
		G.save()
		$WinOrLose.game_over("win")

#######################
#Выбор цвета для фигуры
#######################

func choice_grid_tile(type_for_grid_tile) -> Vector2i:
	var tile: Vector2i
	
	tile = Vector2i(type_for_grid_tile % 4, int(type_for_grid_tile / 4))
	
	return tile

##########################
#Определение центра фигуры
##########################

func get_figure_center() -> int:
	var center: int
	
	if type == 0:
		center = 0
	elif type == 1 || type == 2 || type == 3 || type == 4:
		center = 2
	elif type == 5:
		center = 0
	elif type == 6:
		center = 1
	
	return center

###########
#Новая игра
###########

func new_game() -> void:
	G.game = true
	
	if G.d == "2d":
		G.games_played_2d += 1
		$D/Animation.play("GAME")
		
		if G.setting_animation == false:
			$D/Animation.seek(1)
	
	elif G.d == "3d":
		G.games_played_3d += 1
	
	G.is_achievement_completed("game_played")
	
	G.save()
	
	score = 0
	layers = 0
	
	if G.mode == "classic":
		speed = 1
	
	update_map("start")
	
	if G.d == "2d":
		update_background()
	
	elif G.d == "3d":
		upadate_position_camera()
	
	mode_setting(G.mode)
	
	update_info()
	update_teak()
	
	start_timers()
	
	spawn()

################
#Обновить карту
################

func update_map(action: String) -> void:
	if G.d == "2d":
		if action == "start":
			$D/MainMap.clear()
			
			type = 11
			
			for i in range(12):
				set_main_cell(Vector2(i, 0))
			
			for i in range(12):
				set_main_cell(Vector2(i, 21))
			
			for j in range(20):
				set_main_cell(Vector2(0, j + 1))
			
			for j in range(20):
				set_main_cell(Vector2(11, j + 1))
		
		elif action == "new_theme":
			if G.game == true:
				var save_type: int = type
				for i in range(18):
					for j in range(22):
						var gird_tile: Vector2i = $D/MainMap.get_cell_atlas_coords(0, Vector2i(i, j))
						var phantom_gird_tile: Vector2i = $D/PhantomMap.get_cell_atlas_coords(0, Vector2i(i, j))
						
						type = gird_tile.y * 4 + gird_tile.x
						set_main_cell(Vector2(i, j))
						
						type = phantom_gird_tile.y * 4 + phantom_gird_tile.x
						set_phantom_cell(Vector2(i, j))
				
				for i in range(4):
					for j in range(2):
						var gird_tile: Vector2i = $Info/NextFigureMap.get_cell_atlas_coords(0, Vector2i(i + 1, j + 11))
						
						type = gird_tile.y * 4 + gird_tile.x
						
						set_next_cell(Vector2(i + 1, j + 11))
				
				type = save_type
	
	elif G.d == "3d":
		$D/MainMap.clear()
		
		type = 9
		
		for i in range(size_map_3d):
			for k in range(size_map_3d):
				set_main_cell(Vector3i(i + 1, 0, k + 1))
		
		type = 10
		
		for i in range(size_map_3d):
			for j in range(20):
				set_main_cell(Vector3i(i + 1, j + 1, 0))
		
		for j in range(20):
			for k in range(size_map_3d):
				set_main_cell(Vector3i(0, j + 1, k + 1))
		
		for i in range(size_map_3d):
			for j in range(20):
				set_main_cell(Vector3i(i + 1, j + 1, size_map_3d + 1))
		
		for j in range(20):
			for k in range(size_map_3d):
				set_main_cell(Vector3i(size_map_3d + 1, j + 1, k + 1))

################
#Настройка режим
################

func mode_setting(mode: String) -> void:
	if mode == "classic":
		$Info/Classic.visible = true
	
	else:
		$Info/Levels.visible = true
		var number_level: int = int(mode.replace("_level", "")) - 1
	
		speed = number_level
		create_level_map(number_level)
	
	update_goal()

func update_goal() -> void:
	if G.d == "2d":
		if G.mode == "1_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(3)
		elif G.mode == "4_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(9)
		elif G.mode == "6_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(7)
		elif G.mode == "7_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(9)
		elif G.mode == "9_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(13)
		elif G.mode == "11_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(15)
		elif G.mode == "12_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(15)
		else:
			$Info/Levels/Goal.text = tr("$Touch_the_floor")
	
	elif G.d == "3d":
		if G.mode == "1_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(3)
		elif G.mode == "7_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(9)
		elif G.mode == "8_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(13)
		elif G.mode == "9_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(13)
		elif G.mode == "10_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(13)
		elif G.mode == "11_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(15)
		elif G.mode == "12_level":
			$Info/Levels/Goal.text = tr("$Break_layers") + ": " + str(15)
		else:
			$Info/Levels/Goal.text = tr("$Touch_the_floor")

#####################
#Создать карту уровня
#####################

func create_level_map(number_level: int) -> void:
	var file: FileAccess = FileAccess.open("res://other/levels_maps.json", FileAccess.READ)
	var test_json_conv: JSON = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var level_map: Variant = test_json_conv.get_data()
	
	if G.d == "2d":
		for x in range(10):
			for y in range(20):
				var cell: int = level_map[0][number_level][y][x]
				
				if cell == 1:
					type = 7
					set_main_cell(Vector2(x + 1, y + 1))
				elif cell == 2:
					type = 8
					set_main_cell(Vector2(x + 1, y + 1))
	
	elif G.d == "3d":
		for y in range(20):
			for z in range(size_map_3d):
				for x in range(size_map_3d):
					var cell = level_map[1][number_level][y][z][x]
					
					if cell == 1:
						type = 7
						set_main_cell(Vector3(x + 1, y + 1, z + 1))
					elif cell == 2:
						type = 8
						set_main_cell(Vector3(x + 1, y + 1, z + 1))

#############
#Обновить фон
#############

func update_background() -> void:
	$Backround.texture = CanvasTexture.new()
	
	if G.setting_theme_2d == 0:
		$Backround.modulate = Color("ffffff")
		$Backround.texture = load("res://textures/backgrounds/theme_0.png")
		G.background_color = Color("000000")
	elif G.setting_theme_2d == 1:
		$Backround.modulate = Color("202020")
		G.background_color = Color("9ead86")
	elif G.setting_theme_2d == 2:
		$Backround.modulate = Color("b2f0ff")
		G.background_color = Color("b2f0ff")
	elif G.setting_theme_2d == 3:
		$Backround.modulate = Color("000000")
		G.background_color = Color("000000")
	elif G.setting_theme_2d == 4:
		$Backround.modulate = Color("202020")
		G.background_color = Color("ffd396")
	elif G.setting_theme_2d == 5:
		$Backround.modulate = Color("ffffff")
		$Backround.texture = load("res://textures/backgrounds/theme_5.png")
		G.background_color = Color("e5e5d7")
	
	$D/Backround.color = G.background_color

##########################
#Обновить фантомную фигуру
##########################

func update_setting_phantom_figure_2d() -> void:
	change_phantom_figure()
	
	if G.game == true:
		$D/PhantomMap.visible = G.setting_phantom_figure_2d

func update_setting_phantom_figure_3d() -> void:
	change_phantom_figure()
	
	if G.game == true:
		$D/PhantomMap.visible = G.setting_phantom_figure_3d

######################
#Есть ли `чужие` тайлы
######################

func other_tiles(tiles: Array) -> bool:
	var other_tile = false
	
	if G.d == "2d":
		for i in range(4):
			if $D/MainMap.get_cell_source_id(0, tiles[i]) != -1:
				if tiles[i] in now_figure_tiles:
					pass
				else:
					other_tile = true
	elif G.d == "3d":
		for i in range(4):
			if $D/MainMap.get_cell_item(tiles[i]) != -1:
				if tiles[i] in now_figure_tiles:
					pass
				else:
					other_tile = true
	
	return other_tile

##############################
#Установить или удалить клетки
##############################

func set_main_cell(position_tiles) -> void:
	if G.d == "2d":
		$D/MainMap.set_cell(0, position_tiles, G.setting_theme_2d, choice_grid_tile(type))
	elif G.d == "3d":
		$D/MainMap.set_cell_item(position_tiles, type)

func remove_main_cell(position_tiles) -> void:
	if G.d == "2d":
		$D/MainMap.set_cell(0, position_tiles, -1)
	elif G.d == "3d":
		$D/MainMap.set_cell_item(position_tiles, -1)

func set_phantom_cell(position_tiles) -> void:
	if G.d == "2d":
		$D/PhantomMap.set_cell(0, position_tiles, G.setting_theme_2d, choice_grid_tile(type))
	elif G.d == "3d":
		$D/PhantomMap.set_cell_item(position_tiles, type)

func set_next_cell(position_tiles) -> void:
	$Info/NextFigureMap.set_cell(0, position_tiles, G.setting_theme_2d, choice_grid_tile(type))

###########
#Обновления
###########

func update_info() -> void:
	if G.mode == "classic":
		if G.d == "2d":
			if score > G.best_score_2d:
				G.best_score_2d = score
				
				G.is_achievement_completed("score")
				
				G.save()
		
		elif G.d == "3d":
			if score > G.best_score_3d:
				G.best_score_3d = score
				
				G.is_achievement_completed("score")
				
				G.save()
		
		$Info/Classic/Score.text = str(score)
		$Info/Classic/Layers.text = str(layers)
		$Info/Classic/Speed.text = str(speed)
	
	else:
		$Info/Levels/Layers.text = str(layers)

func update_teak() -> void:
	$TimerTeak.wait_time = 0.8-((speed-1)*0.07)
	$TimerFastTeak.wait_time = (0.8-((speed-1)*0.07)) / 10

######################
#Старт и стоп таймеров
######################

func start_timers() -> void:
	$TimerTeak.start()
	$TimerFastTeak.start()
	$TimerIntervalShift.start()

func stop_timers() -> void:
	$TimerTeak.stop()
	$TimerFastTeak.stop()
	$TimerIntervalShift.stop()

########
#Таймеры
########

func _on_timer_teak_timeout():
	if fast_descent == false:
		move_figure("down")

func _on_timer_fast_teak_timeout():
	if fast_descent == true:
		score += 1
		move_figure("down")
		
		update_info()

func _on_timer_interval_shift_timeout():
	interval_shift = true
	$TimerIntervalShift.stop()

###########
#Управление
###########

func _process(_delta: float) -> void:
	if G.setting_display_fps == true:
		$FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if G.game == true:
		fast_descent = false 
		
		if G.d == "2d":
			#управление 2d
			if layers_break_now == false:
				if Input.is_action_just_pressed("move_figure_right_2d"):
					interval_shift = true
				
				if Input.is_action_just_pressed("move_figure_left_2d"):
					interval_shift = true
				
				if interval_shift == true:
					if Input.is_action_pressed("move_figure_right_2d"):
						move_figure("right")
						$TimerIntervalShift.start()
						interval_shift = false
					
					if Input.is_action_pressed("move_figure_left_2d"):
						move_figure("left")
						$TimerIntervalShift.start()
						interval_shift = false
				
				if Input.is_action_pressed("fast_move_figure_down_2d"):
					fast_descent = true
				
				if Input.is_action_just_pressed("drop_figure_2d"):
					var layers_for_descent: int = 0
					while new_figure == false:
						layers_for_descent += 1
						move_figure("down")
					score += (layers_for_descent - 1) * 2
						
					update_info()
				
				if Input.is_action_just_pressed("turn_figure_right_z_2d"):
					turn_figure("z", "right")
				if Input.is_action_just_pressed("turn_figure_left_z_2d"):
					turn_figure("z", "left")
		
		elif G.d == "3d":
			#управлние 3d
			
			if Input.is_action_just_pressed("move_figure_right_3d"):
				interval_shift = true
			
			if Input.is_action_just_pressed("move_figure_left_3d"):
				interval_shift = true
			
			if Input.is_action_just_pressed("move_figure_forward_3d"):
				interval_shift = true
			
			if Input.is_action_just_pressed("move_figure_back_3d"):
				interval_shift = true
			
			if interval_shift == true:
				if Input.is_action_pressed("move_figure_right_3d"):
					move_figure("right")
					$TimerIntervalShift.start()
					interval_shift = false
				
				if Input.is_action_pressed("move_figure_left_3d"):
					move_figure("left")
					$TimerIntervalShift.start()
					interval_shift = false
			
			if interval_shift == true:
				if Input.is_action_pressed("move_figure_forward_3d"):
					move_figure("forward")
					$TimerIntervalShift.start()
					interval_shift = false
				
				if Input.is_action_pressed("move_figure_back_3d"):
					move_figure("back")
					$TimerIntervalShift.start()
					interval_shift = false
			
			if Input.is_action_pressed("fast_move_figure_down_3d"):
				fast_descent = true
			
			if Input.is_action_just_pressed("drop_figure_3d"):
				var layers_for_descent = 0
				while new_figure == false:
					layers_for_descent += 1
					move_figure("down")
				score += (layers_for_descent - 1) * 2
				
				update_info()
			
			if Input.is_action_just_pressed("turn_figure_left_z_3d"):
				turn_figure("z", "left")
			if Input.is_action_just_pressed("turn_figure_right_z_3d"):
				turn_figure("z", "right")
			
			if Input.is_action_just_pressed("turn_figure_left_x_3d"):
				turn_figure("x", "left")
			if Input.is_action_just_pressed("turn_figure_right_x_3d"):
				turn_figure("x", "right")
			
			if Input.is_action_just_pressed("turn_figure_left_y_3d"):
				turn_figure("y", "left")
			if Input.is_action_just_pressed("turn_figure_right_y_3d"):
				turn_figure("y", "right")
			
			if Input.is_action_just_pressed("move_camera_up_3d"):
				if camera_height != 20:
					camera_height += 1
			if Input.is_action_just_pressed("move_camera_down_3d"):
				if camera_height != 0:
					camera_height -= 1
			
			if Input.is_action_just_pressed("reset_camera_position_3d"):
				alpha_camera_3d = 1
				beta_camera_3d = 1
			
			radius_camera_3d += (k_radius_camera_3d - radius_camera_3d) * 0.1
			
			upadate_position_camera()
		
		new_figure = false
		
		update_info()

###############################
#Приближение и отдаление камеры
###############################

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == 4:
		if k_radius_camera_3d > 1:
			k_radius_camera_3d -= 1
	
	if event is InputEventMouseButton and event.button_index == 5:
		if k_radius_camera_3d < 30:
			k_radius_camera_3d += 1

##########################
#Обновление позиции камеры
##########################

func upadate_position_camera() -> void:
	$D/Camera.rotation.y = PI / 2 - alpha_camera_3d
	$D/Camera.rotation.x = -PI / 2 + beta_camera_3d
	
	$D/Camera.position.z = radius_camera_3d * sin(beta_camera_3d) * sin(alpha_camera_3d) + 1 + size_map_3d / 2.0
	$D/Camera.position.y = radius_camera_3d * cos(beta_camera_3d) + 1 + camera_height
	$D/Camera.position.x  = radius_camera_3d * cos(alpha_camera_3d) * sin(beta_camera_3d) + 1 + size_map_3d / 2.0

##########################
#Управление для телефона 2
##########################

func _input(event):
	if G.d == "3d":
		if G.game == true:
			if event is InputEventScreenDrag:
				alpha_camera_3d += event.relative.x / 100 * G.setting_sensitivity
				beta_camera_3d += - event.relative.y / 100 * G.setting_sensitivity

func _on_up_pressed():
	turn_figure("z", "right")

func _on_down_pressed():
	phone_button_down = true

func _on_down_released():
	phone_button_down = false

func _on_right_pressed():
	phone_button_right = true

func _on_right_released():
	phone_button_right = false

func _on_left_pressed():
	phone_button_left = true

func _on_left_released():
	phone_button_left = false

func _on_space_pressed():
	var layers_for_descent = 0
	while new_figure == false:
		layers_for_descent += 1
		move_figure("down")
	G.score += (layers_for_descent - 1) * 2
	
	update_info()

func _on_z_pressed():
	turn_figure("z", "left")
