extends Node


var jumps = 2
var motion = Vector2(0, -1)
var canDash
var direction = Vector2(0, -1)
var gravity = 20
var vFlip = false
var jump = -500
var walljumpx = 400
var wallJumpY = 400
var live = true
var timer = 0
var muted = false
var temp = 0
var deaths = 0
const SPRING = -1000

func upGravity():
	print("gravity up")
	direction = Vector2(0, 1)
	gravity = -20
	vFlip = true
	jump = 500
	#walljumpx = -400
	wallJumpY = -400
	
func downGravity():
	print("gravity down")
	direction = Vector2(0, -1)
	gravity = 20
	vFlip = false
	jump = -500
	#walljumpx = 400
	wallJumpY = 400

func _ready():
	downGravity()
	
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
	live = true

func _physics_process(delta):
	if( Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_mute"):
		if(muted == false):
			muted = true
			temp = MusicPlayer.get_playback_position()
			MusicPlayer.stop()
			print("muted")
		else:
			print("unmuted")
			MusicPlayer.play(temp)
			muted = false




