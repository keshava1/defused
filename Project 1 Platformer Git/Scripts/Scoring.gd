extends Node2D


# Declare member variables here. Examples:
var time 
var deaths 
var points

# Called when the node enters the scene tree for the first time.
func _ready():
	#get these nodes
	var time = int(PlayerVars.timer)
	var deaths = PlayerVars.deaths
	var points = 9999 - int(time)*2 - deaths*10
	$VBoxContainer/Points.text = "9,999 points\n-\n" + str(time) + " seconds\n-\n" + str(deaths) + " deaths\n=\n" + str(points) + " points"
	PlayerVars.newScore(points)
#func _process(delta):
#	if(Input.is_action_just_pressed("ui_accept")):
#		MusicPlayer.stop()
#		get_tree().change_scene("res://StartMenu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	MusicPlayer.stop()
	get_tree().change_scene("res://StartMenu.tscn")
