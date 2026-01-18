extends Node

var banner_ad_view : AdView

var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()

var GameLost : int = 1

var Banner_unit_id : String = "ca-app-pub-5895418107930733/4484585937"
var Interstitial_unit_id : String = "ca-app-pub-5895418107930733/7425609890"
func _ready():
	MobileAds.initialize()
	
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded
	
func LoadedBanner():

	banner_ad_view = AdView.new(Banner_unit_id,AdSize.LARGE_BANNER,AdPosition.Values.BOTTOM)
	
	banner_ad_view.load_ad(AdRequest.new())

func StopLoading():
	banner_ad_view.destroy()


func _on_load_interstitial_pressed() -> void:

	InterstitialAdLoader.new().load(Interstitial_unit_id, AdRequest.new(), interstitial_ad_load_callback)

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)

func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	self.interstitial_ad = interstitial_ad

func _on_show_pressed():
	if interstitial_ad:
		interstitial_ad.show()
		GameLost = 1

func gamelost():
	GameLost -= 1
