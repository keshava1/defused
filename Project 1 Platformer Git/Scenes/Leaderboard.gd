extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/S1.text = "1st place: " + str(PlayerVars.score1)
	$CenterContainer/VBoxContainer/S2.text = "2nd place: " + str(PlayerVars.score2)
	$CenterContainer/VBoxContainer/S3.text = "3rd place: " + str(PlayerVars.score3)
	$CenterContainer/VBoxContainer/S4.text = "4th place: " + str(PlayerVars.score4)
	$CenterContainer/VBoxContainer/S5.text = "5th place: " + str(PlayerVars.score5)
func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://StartMenu.tscn")
