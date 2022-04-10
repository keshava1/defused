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

