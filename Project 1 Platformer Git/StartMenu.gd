extends Control

var l1 = "res://World.tscn"

func _on_StartGame_pressed():
	PlayerVars.twoP = false
	startUp()
	PlayerVars.hardMode = false
	get_tree().change_scene(l1)
	


func _on_QuitGame_pressed():
	get_tree().quit()


func _on_Levels_pressed():
	get_tree().change_scene("res://Scenes/Levels.tscn")


func _on_Leaderboard_pressed():
	get_tree().change_scene("res://Scenes/Leaderboard.tscn")


func _on_Hard_Mode_pressed():
	PlayerVars.twoP = false
	PlayerVars.hardMode = true
	startUp()
	
	get_tree().change_scene(l1)


func _on_2PN_pressed():
	PlayerVars.twoP = true
	startUp()
	PlayerVars.hardMode = false
	
	get_tree().change_scene(l1)


func _on_2PH_pressed():
	PlayerVars.twoP = true
	PlayerVars.hardMode = true
	startUp()
	get_tree().change_scene(l1)
func startUp():
	PlayerVars.timer = 0
	PlayerVars.deaths = 0
	if(PlayerVars.muted == false):
		MusicPlayer.play()
		
func _ready():
	MusicPlayer.stop()
	MusicPlayer.volume_db = 1
