extends Node

# variables that the player uses
var jumps = 2
var motion = Vector2(0, -1)
var canDash
var direction = Vector2(0, -1)
var gravity = 20
var vFlip = false
var jump = -500
var walljumpx = 400
var wallJumpY = 400
var offset = 0
var timer = 0
var muted = true
var temp = 0.0
var deaths = 0
var hardMode = false
var dying = false
#score variables
var score1 = 0
var score2 = 0
var score3 = 0
var score4 = 0
var score5 = 0
# spring constant
const SPRING = -1000
#make gravity upwards
func upGravity():
	print("gravity up")
	direction = Vector2(0, 1)
	gravity = -20
	vFlip = true
	jump = 500
	#walljumpx = -400
	wallJumpY = -400
	offset = 40
# make gravity downwards
func downGravity():
	print("gravity down")
	direction = Vector2(0, -1)
	gravity = 20
	vFlip = false
	jump = -500
	#walljumpx = 400
	wallJumpY = 400
	offset = 0
#on ready, make gravity down
func _ready():
	downGravity()
	if(muted == true):
		temp = MusicPlayer.get_playback_position()
		MusicPlayer.stop()
		print("muted")
	else:
		print("unmuted")
		MusicPlayer.play(temp)
#resets vars
func reset():
	jumps = 2
	motion = Vector2(0, -1)
	canDash
	direction = Vector2(0, -1)
	gravity = 20
	vFlip = false
	jump = -500
	walljumpx = 400
	wallJumpY = 400
	dying = false
	offset = 0
#check for exit, mute, and more
func _physics_process(delta):
	if( Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_mute"):
		if(muted == false):
			temp = MusicPlayer.get_playback_position()
			MusicPlayer.stop()
			print("muted")
		else:
			print("unmuted")
			MusicPlayer.play(temp)
		muted = !muted



#add a new score
func newScore(score):
	var temp = score
	var temp2
	if(score > score1):
		temp = score1
		score1 = score
	if(temp > score2):
		temp2 = score2
		score2 = temp
		temp = temp2
	if(temp > score3):
		temp2 = score3
		score3 = temp
		temp = temp2
	if(temp > score4):
		temp2 = score4
		score4 = temp
		temp = temp2
	if(temp > score5):
		temp2 = score5
		score5 = temp
		temp = temp2




