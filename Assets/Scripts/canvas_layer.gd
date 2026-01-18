extends CanvasLayer

@onready var timepassed_text = $TimePassed
@onready var scoreText = $score
@onready var GameOverNode = $GameOver
@onready var TotalScore = $GameOver/TotalScore
@onready var highscore = $GameOver/HighScore
@onready var PauseMenu = $Pause
@onready var EggPlusText = $PlusEgg
@onready var eggupanim = $PlusEgg/AnimationPlayer


var time_passed  = 1
var number_egg = 12
var path = "user://save_data"
var TimePath = "user://save_time"


var pauseBool : bool = false
var GameOverScreen : bool 


func _ready():

	GameOverScreen = false
	pauseBool = false
	#animplay()
	GameOverNode.hide()
	PauseMenu.hide()
	get_tree().quit_on_go_back = false
	
	
func _physics_process(delta):
	time_passed += delta
	#print(int(time_passed))
	$TimePassed.text = "Time : " + str(round_place(time_passed,2))


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
		

func _on_home_pressed():
	ButtonClick.playsound()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_restart_pressed():
	ButtonClick.playsound()
	print("something")
	GameOverNode.visible = false
	get_tree().reload_current_scene() 



func _on_pause_pressed():
	PauseMenu.show()
	$pause.visible = false
	$pause.disabled = true
	get_tree().paused = true
	ButtonClick.playsound()
	pauseBool = true

func _on_resume_pressed():
	PauseMenu.hide()
	$pause.visible = true
	$pause.disabled = false
	get_tree().paused = false
	ButtonClick.playsound()
	pauseBool = false
	
func animplay():
	eggupanim.play("PlusEgg")
	$PlusEgg/AudioStreamPlayer2D.playing = true

func SaveData(score):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(str(score))
	file = null

func LoadData():
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		var content = file.get_as_text()
		return content
	return 0

func SaveTimePassed(timepassed):
	var file = FileAccess.open(TimePath,FileAccess.WRITE)
	file.store_string(str(timepassed))
	file = null 
	
func LoadTimePassed():
	if FileAccess.file_exists(TimePath):
		var file = FileAccess.open(TimePath,FileAccess.READ)
		var content = file.get_as_text()
		return content 
	
	return 0


func _notification(what):
	if !GameOverScreen:
		if what == NOTIFICATION_WM_GO_BACK_REQUEST:
			if pauseBool:
				_on_resume_pressed()
			else:
				_on_pause_pressed()
			
		#pauseBool = !pauseBool


	
