extends ScrollContainer

func _input(event):
	if event is InputEventScreenDrag:
		if G.scroll == true:
			if is_visible_in_tree() == true:
				scroll_vertical -= event.relative.y
