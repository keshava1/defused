extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 275
const JUMP = -500
const ACCELERATION = 50
const MAX_JUMPS = 2
const DEATH_HEIGHT = 1000
const SPRING = -1000
var jumps = MAX_JUMPS
var motion = Vector2()
var walljumpx = 400
var wallJumpY = 400
#var soup = 5

# Did this get to github?
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	motion = PlayerVars.motion
	jumps = PlayerVars.jumps
	
	motion.y += GRAVITY
	var friction = false
	
	if get_position().y > DEATH_HEIGHT:
		respawn()
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		friction = true
		$Sprite.play("Idle")
		
	#print(motion.x)
	if is_on_floor() or nextToWall():
		if is_on_floor():
			jumps = MAX_JUMPS
		if friction == true:
			motion.x = lerp(motion.x, 0,0.6);
		if Input.is_action_just_pressed("ui_up") and (jumps > 0 or nextToWall()):
			
			if (not is_on_floor()) and nextToRightWall():
				motion.x = -walljumpx
				motion.y = -wallJumpY
			elif (not is_on_floor()) and nextToLeftWall():
				motion.x = walljumpx
				motion.y = -wallJumpY
			else:
				motion.y = JUMP
				jumps -= 1
		if nextToWall() and motion.y > MAX_SPEED / 2:
			motion.y = MAX_SPEED / 2

	else:
		if Input.is_action_just_pressed("ui_up") and jumps > 0:
			motion.y = JUMP * 0.75
			jumps -= 1
		if motion.y < 0 && jumps >= 1:
			$Sprite.play("Jump")
		elif motion.y < 0 && jumps ==0:
			$Sprite.play("Jump2")
		else:
			$Sprite.play("Fall")
		if friction == true:
			motion. x = lerp(motion.x, 0, 0.1)
	motion = move_and_slide(motion, UP)
	PlayerVars.motion = motion
	PlayerVars.jumps = jumps

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()

func respawn():
	get_tree().reload_current_scene()


#func _on_Spring_body_entered(body):
#	if body.name == "Player":
#		motion.y = SPRING
