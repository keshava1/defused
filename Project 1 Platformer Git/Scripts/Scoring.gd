extends Node2D


# Declare member variables here. Examples:
var time 
var deaths 
var points

# Called when the node enters the scene tree for the first time.
func _ready():
	var time = int(PlayerVars.timer)
	var deaths = PlayerVars.deaths
	var points = 9999 - int(time) - deaths*10
	$VBoxContainer/Points.text = "9,999 points\n-\n" + str(time) + " seconds\n-\n" + str(deaths) + " deaths\n=\n" + str(points) + " points"
	PlayerVars.newScore(points)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
