extends Area2D

var Score = 5
@onready var animation = $Label/AnimationPlayer
@onready var label = $Label

func _on_body_entered(body):
	get_parent().AddScore(Score)
	$AudioStreamPlayer2D.playing = true
	$CollisionShape2D.queue_free()
	$AnimatedSprite2D.visible = false
	#print(get_parent().score)
	var starScore_Modifier : int= 0
	starScore_Modifier = get_parent().score / 500
	if starScore_Modifier > 5:
		starScore_Modifier = 5
	label.text = "+" + str(50 + (starScore_Modifier * 10))
	animation.play("scoreanim")
	
