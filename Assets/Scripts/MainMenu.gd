extends CanvasLayer

var settingbool = false
@onready var mainmenu = $MainMenu
@onready var settingsmenu = $SettingsMenu



var SoundBus
var SoundBus2
var MusicBus
var MusicBus2

@onready var MusicButton = $SettingsMenu/Music
@onready var SoundButton = $SettingsMenu/Sound



var path = "user://save_data"
#@onready var ClickSound = $AudioStreamPlayer2D



func _ready():
	OS.request_permissions()
	get_tree().quit_on_go_back = false
	
	#ShowAds.LoadedBanner()#LoadBannerAds
	
	print("LoadingAd")

	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		var content = file.get_as_text()
		$MainMenu/HighScore.text = "HighScore : " + content
	SoundBus = AudioServer.get_bus_index("pop")
	SoundBus2= AudioServer.get_bus_index("EggUp")
	MusicBus = AudioServer.get_bus_index("guitar")
	MusicBus2 = AudioServer.get_bus_index("birds")
	
	MusicButton.button_pressed = ButtonSave.ButtonDict["MusicButton"]
	SoundButton.button_pressed = ButtonSave.ButtonDict["SoundButton"]

func _on_play_button_pressed():
	
	ButtonClick.playsound()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	



func _on_settings_pressed():
	
	ButtonClick.playsound()
	settingbool = !settingbool
	if settingbool:
		settingsmenu.visible = true
		mainmenu.visible = false
	else:
		settingsmenu.visible = false
		mainmenu.visible = true
		
	


func _on_sound_toggled(toggled_on):
	if toggled_on:
		AudioServer.set_bus_mute(SoundBus,false)
		AudioServer.set_bus_mute(SoundBus2,false)
		SoundButton.button_pressed = true
		ButtonSave.ButtonDict["SoundButton"] = true
		ButtonClick.playsound()

	else:

		AudioServer.set_bus_mute(SoundBus,true)
		AudioServer.set_bus_mute(SoundBus2,true)
		SoundButton.button_pressed = false
		ButtonSave.ButtonDict["SoundButton"] = false
		ButtonClick.playsound()
		
		


func _on_music_toggled(toggled_on):
	if toggled_on:
		AudioServer.set_bus_mute(MusicBus,false)
		AudioServer.set_bus_mute(MusicBus2,false)
		MusicButton.button_pressed = true
		ButtonSave.ButtonDict["MusicButton"] = true
		ButtonClick.playsound()

	else:
		AudioServer.set_bus_mute(MusicBus,true)
		AudioServer.set_bus_mute(MusicBus2,true)
		MusicButton.button_pressed = false
		ButtonSave.ButtonDict["MusicButton"] = false
		ButtonClick.playsound()


