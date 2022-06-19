extends Control



func _on_StartGame_pressed():
	PlayerVars.timer = 0
	PlayerVars.deaths = 0
	
	get_tree().change_scene("res://World.tscn")
	


func _on_QuitGame_pressed():
	get_tree().quit()


func _on_Levels_pressed():
	get_tree().change_scene("res://Scenes/Levels.tscn")


func _on_Leaderboard_pressed():
	get_tree().change_scene("res://Scenes/Leaderboard.tscn")


func _on_Hard_Mode_pressed():

	PlayerVars.hardMode = true
	_on_StartGame_pressed()
