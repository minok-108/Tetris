extends Node2D

func _ready():
	$Animation.get_animation("PLAY").track_set_key_value(0, 1, G.background_color)
	
	$Animation.play("PLAY")
	await $Animation.animation_finished
	queue_free()
