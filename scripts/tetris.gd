extends Control

func _ready():
	$Animation.play("PLAY")
	if G.setting_particles == false:
		$Animation.seek(1.5)
	
	if G.setting_particles == true:
		$Particle.restart()
	
	await $Animation.animation_finished
	queue_free()
