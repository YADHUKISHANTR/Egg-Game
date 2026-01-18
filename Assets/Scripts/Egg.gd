extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1100.0

var eggCanJump : bool = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	
	eggRespawn()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		$AnimationPlayer.play("rotation")
		velocity.y += gravity * delta
	
	if is_on_floor():
		$AnimationPlayer.play("RESET")
		if Input.is_action_just_pressed("ui_accept") and eggCanJump:
			velocity.y = JUMP_VELOCITY
			$AudioStreamPlayer2D.playing = true
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()

func eggRespawn():
	$AnimationPlayer.stop()
	#$Sprite2D.play("EggRespawn")
	$AnimationPlayer.play("RESET")
	
func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed and is_on_floor() and eggCanJump:
			#velocity.y = JUMP_VELOCITY
			#$AudioStreamPlayer2D.playing = true
		#else:
			#pass
	
	if event is InputEventScreenTouch:
		
		#print(event.position)
		if event.position.y < get_viewport().size.y - 100:
			if event.pressed and is_on_floor() and eggCanJump:
				velocity.y = JUMP_VELOCITY
				$AudioStreamPlayer2D.playing = true
			else:
				pass




