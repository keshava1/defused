extends Control



func _on_StartGame_pressed():
	get_tree().change_scene("res://Scenes/World7.tscn")


func _on_QuitGame_pressed():
	get_tree().quit()


func _on_Levels_pressed():
	get_tree().change_scene("res://Scenes/Levels.tscn")


func _on_Leaderboard_pressed():
	get_tree().change_scene("res://Scenes/Leaderboard.tscn")
