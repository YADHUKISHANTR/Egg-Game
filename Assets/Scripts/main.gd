extends Node

@onready var Camera2d =  $Camera2D
@onready var egg = $Egg
@onready var raycast = $Egg/RayCast2D2
@onready var canvaslayer = $CanvasLayer


@export var cameraSpeed : int = 500
const random_starinst : int = 3

var basket_node = preload("res://scenes/baskettest.tscn")
var particle_effect = preload("res://scenes/particles.tscn")
var star = preload("res://scenes/star.tscn")
var screenzise 
var previouscollider
var cameraHeight
var viewportsize
var bound
var basketisatbottom : bool = true
var numofbasket : int = 0
var instantiated_basket_num = 2
var basket_list = []
var star_list = []
var score : int = 0
var HighScore : int = 0

var EGG_PLUS_SCORE = 200 #+1 egg is awarded when this score gets 


func _ready():
	#ShowAds.StopLoading()#stopbannerads
	
	#ShowAds._on_load_interstitial_pressed()#LoadInterstitial
	
	#ShowAds.gamelost()
	
	
	#if ShowAds.GameLost <= 0:
		#ShowAds._on_show_pressed()#show interstitial
	
	HighScore = int(canvaslayer.LoadData())
	print(HighScore)
	get_tree().paused = false
	cameraHeight = Camera2d.global_position.y
	viewportsize = get_viewport().size.y 
	bound = cameraHeight + viewportsize
	basket_list.append($StartBasket)
	basket_list.append($StartBasket2)
	basket_list.append($StartBasket3)
	screenzise = get_window().size.y
	instParticle()
	#print(screenzise)
	#canvaslayer.eggphoto[12].visible = false



func _physics_process(delta):
	
	if Input.is_action_pressed("UP"):
		CameraMoving(delta)
		
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if egg.is_on_floor():
			if previouscollider:
				if previouscollider != collider:
					score += 10
					#print(score)
					#when score hits the limit one egg is given
					####################################################
					
					Bonus()

					canvaslayer.scoreText.text = "Score : " + str(score)
					collider.get_parent().stopTimer = true
					
			egg.z_index = 0
			previouscollider = collider
			egg.position.x = collider.global_position.x
			
			
			
		
			#print("collision detected")
		#print(collider.global_position.x,egg.position.x)
	else:
		egg.z_index = 2
		#print("collision not detected")
		if previouscollider:
			previouscollider.visible = false
			previouscollider.collision_layer = 2
	
	if egg.global_position.y >= bound + 800:
		#print(egg.global_position.y)
		Reset_Egg()
		
	
	#when egg reach top camera should move up
	if previouscollider:
		if previouscollider.global_position.y < cameraHeight + 480:
			basketisatbottom = false
			#instantiating newbasket at the top
			while instantiated_basket_num > 0:
				var basket_pos : Vector2 = Vector2(previouscollider.global_position.x - 60,previouscollider.global_position.y - (490 * instantiated_basket_num) )
				inst_basket(basket_pos)
				var randomstar = randi_range(1,random_starinst)
				if randomstar == 1:
					#var star_pos : Vector2 =  Vector2(randi_range(50,720),previouscollider.global_position.y - (300 * instantiated_basket_num) )
					var star_pos : Vector2 =  Vector2(previouscollider.get_parent().global_position.x + 38,previouscollider.global_position.y - (360 * instantiated_basket_num) )
					instStar(star_pos)
					print("spawned")
				instantiated_basket_num -= 1
		
		
	
	if not basketisatbottom:
		egg.eggCanJump = false
		CameraMoving(delta)
		
	
#returning the egg to the previous basket when its go down
func Reset_Egg():
	instParticle()
	if canvaslayer.number_egg > 0:
		canvaslayer.number_egg -= 1
		canvaslayer.get_node("eggsnum/" + str(canvaslayer.number_egg+1)).visible = false
		if canvaslayer.number_egg <= 0:
			GameOver()
			
		#print(canvaslayer.number_egg)
	egg.eggRespawn()
	
	
	
	
	if previouscollider:
		previouscollider.collision_layer = 1
		previouscollider.visible = true
		egg.global_position = previouscollider.global_position -  Vector2(0,30)

#Camera move when the egg reach the top
func CameraMoving(delta):
	cameraHeight = Camera2d.global_position.y
	#print(bound)
	bound = cameraHeight + viewportsize
	Camera2d.position.y -= cameraSpeed * delta
	#sotp camera moving when the egg reach down
	if cameraHeight + 1250 <= previouscollider.global_position.y:
		egg.eggCanJump = true
		#print(cameraHeight,previouscollider.global_position.y)
		basketisatbottom = true	
		instantiated_basket_num = 2
		#remove the basket that are out of boundary

		for bs in basket_list:
			if bs.position.y > cameraHeight + 1544:
				bs.global_position.y = previouscollider.global_position.y - 250
				remove_bakset(bs)
		
		for st in star_list:
			if st.position.y > cameraHeight + 1544:
				st.queue_free()
				star_list.erase(st)
				#print(star_list.size())
			
				

func inst_basket(pos):
	var instance = basket_node.instantiate()
	instance.global_position = pos
	instance.speed_modifier = score 
	instance.basketfunc_modifier = score / 320
	
	#print(instance.basket_speed, instance.speed_modifier)
	add_child(instance)
	instance.istrue = true
	basket_list.append(instance)
	
	

	#instance.istrue = true
func remove_bakset(bskt):
	bskt.queue_free()
	basket_list.erase(bskt)
	
	#print("basket_list size = ", basket_list.size())
	

func GameOver():
	#ShowAds.gamelost()

	if $StartBasket/Label:
		$StartBasket/Label.queue_free()
	
	$Egg.visible = false
	get_tree().paused = true
	canvaslayer.GameOverNode.show()
	canvaslayer.GameOverScreen = true
	canvaslayer.TotalScore.text = "score : " + str(score)
	if score > HighScore:
		HighScore = score
		canvaslayer.SaveData(HighScore)
		
	
	canvaslayer.highscore.text = "HighScore : " + str(HighScore)  
	for bskt in basket_list:
		bskt.queue_free()

#
func instParticle():
	var instace = particle_effect.instantiate()
	
	egg.add_child(instace)
	

func instStar(pos):
	var instance = star.instantiate()
	instance.global_position = pos
	star_list.append(instance)
	add_child(instance)

func AddScore(add):
	var starScore_modifier : int = 0
	starScore_modifier = int(score / 500)
	if starScore_modifier > 5:
		starScore_modifier = 5
	for i in (add + starScore_modifier):
		score += 10
		Bonus()
	
	canvaslayer.scoreText.text = "Score : " + str(score)
	
func Bonus():
	if score % EGG_PLUS_SCORE == 0:
		if EGG_PLUS_SCORE > 100:
			EGG_PLUS_SCORE -= 10
							
							
		if canvaslayer.number_egg < 12:
			canvaslayer.EggPlusText.text = "+1  Egg"
			canvaslayer.animplay()
			canvaslayer.number_egg += 1
			canvaslayer.get_node("eggsnum/" + str(canvaslayer.number_egg)).visible = true
		else:
			canvaslayer.EggPlusText.text = "+50 score"
			canvaslayer.animplay()
			score += 50

