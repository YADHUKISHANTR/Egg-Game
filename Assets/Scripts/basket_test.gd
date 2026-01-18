extends Node2D

#enum basket_function{MovingBasket,SlidingBasket,RotatingBasket,InvisibleBasket,ZigzagBasket,MovingAndRotating,MovingAndInvisible}
var basketfunctionarray = ["MovingBasket","StaticBasket","SlidingBasket","RotationBasket","InvisibleBasket","ZigzagBasket","MovingAndRotation","MovingAndInvisible"]
var basketfunc_modifier
const MAX_ARRLENGTH = 7

var direction : int = 1
var invbool = false
var stopTimer = false
var basket_speed
var speed_modifier = 0
@onready var timer = $Timer
@onready var timer2 = $Timer2
const MIN_SPEED : int = 120
const MAX_SPEED : int= 750

const SLMIN_SPEED : int = 20
const SLMAX_SPEED : int = 43
var slide_speed

var current_position
var changedir : bool

@export var bsktfunc : String #to choose the function fron the inspector

@export var istrue : bool = true
@onready var leftRaycast  : RayCast2D = $Area2D/Left
@onready var rightRaycast : RayCast2D = $Area2D/right
var child_node
@onready var egg = $"../Egg"

@onready var animation = $Sprite2D/AnimationPlayer

func _ready():
	
	if !bsktfunc:
		if int(basketfunc_modifier) > MAX_ARRLENGTH - 2:
			basketfunc_modifier = 5
		bsktfunc = basketfunctionarray[randi_range(0,2 + int(basketfunc_modifier))]
		#print(bsktfunc)
		
	#print(bsktfunc)
	
	child_node = $Area2D/CollisionShape2D
	direction = ((randi()%2) * 2) - 1
	basket_speed = randi_range(MIN_SPEED,MIN_SPEED+(speed_modifier/5))
	slide_speed = randi_range(SLMIN_SPEED,SLMIN_SPEED+(speed_modifier/1000))
	#print(direction)
	if bsktfunc == "MovingAndRotation" or bsktfunc == "MovingAndInvisible":
		basket_speed = randi_range(MIN_SPEED,MIN_SPEED+(speed_modifier/20))
		
	if basket_speed > MAX_SPEED:
		basket_speed = MAX_SPEED
	
	if slide_speed > SLMAX_SPEED:
		slide_speed = SLMAX_SPEED
		
		
	if bsktfunc == "InvisibleBasket" or bsktfunc == "MovingAndInvisible":
		animation.play("invisible")
		invisibleBasket()
	elif bsktfunc == "RotationBasket" or bsktfunc == "MovingAndRotation":
		animation.play("rotation")
		$Area2D/CollisionShape2D.disabled = true
		rotatingBasket()
	
	current_position = global_position.y
	
	
func _physics_process(delta):
	if leftRaycast.is_colliding():
		direction = 1
		#print("collided")
	
	if rightRaycast.is_colliding():
		direction = -1
	
	if istrue:
		match bsktfunc:
			"MovingBasket","MovingAndRotation","MovingAndInvisible":
				movingBasket(delta)
			"SlidingBasket":
				slidingBakset(delta)
			"ZigzagBasket":
				zigzagBakset(delta)
				

			
			
	
	if bsktfunc == "InvisibleBasket":
		if $Sprite2D.self_modulate.a <= 0.4:
			$Area2D/CollisionShape2D.disabled = true
		else:
			$Area2D/CollisionShape2D.disabled = false
		
	if stopTimer:
		$Timer.stop()
		$Timer2.stop()
		animation.pause()
		stopTimer = false
		
		
		
	
		
	
func movingBasket(delta):
	
	position.x += direction * basket_speed * delta
	
	if egg.global_position.y < global_position.y + 50:
		child_node.visible = true
		child_node.process_mode = Node.PROCESS_MODE_DISABLED
		
	else:
		child_node.visible = false
		child_node.process_mode = Node.PROCESS_MODE_INHERIT
			

func rotatingBasket():
	timer2.start()
	

func slidingBakset(delta):
	
	position.x += direction * basket_speed * delta
	position.y += direction * slide_speed * delta
	
	if egg.global_position.y < global_position.y + 50:
		child_node.visible = true
		child_node.process_mode = Node.PROCESS_MODE_DISABLED
		
	else:
		child_node.visible = false
		child_node.process_mode = Node.PROCESS_MODE_INHERIT

func invisibleBasket():
	timer.start()
	
func zigzagBakset(delta):
	
	position.x += direction * basket_speed * delta
	
	if global_position.y >= current_position + 30:
		changedir = true
	elif global_position.y <= current_position - 30:
		changedir = false
	
	if changedir:
		position.y -= 50 * delta
	else:
		position.y += 50 * delta
	
	if egg.global_position.y < global_position.y + 50:
		child_node.visible = true
		child_node.process_mode = Node.PROCESS_MODE_DISABLED
		
	else:
		child_node.visible = false
		child_node.process_mode = Node.PROCESS_MODE_INHERIT
		
	
	
func _on_timer_timeout():
	invbool = !invbool
	if !invbool:
		#print("invisible")
		animation.play("invisible")
		
	else:
		#print("visible")
		animation.play("visible")
	



func _on_timer_2_timeout():
	invbool = !invbool
	print(invbool)
	if !invbool:
		#print("invisible")
		animation.play("rotation")
		$Area2D/CollisionShape2D.disabled = true
		$Timer2.wait_time = 3.00
		
	else:
		#print("visible")
		animation.play("rotation_back")
		$Area2D/CollisionShape2D.disabled = false
		$Timer2.wait_time = 1.45
