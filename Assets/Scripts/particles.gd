extends Node2D


func _ready():
	$CPUParticles2D.emitting = true
	$Eggrespawnaudio.playing = true


func _on_timer_timeout():
	print("deleted")
	queue_free()
