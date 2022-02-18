extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 275
const JUMP = -500
const ACCELERATION = 50
const MAX_JUMPS = 2
const DEATH_HEIGHT = 1000
var jumps = MAX_JUMPS
var motion = Vector2()
var wallJump = 400
var jumpWall = 400
#var soup = 5

# Did this get to github?
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(soup)
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
		
	if is_on_floor() or nextToWall():
		if is_on_floor():
			jumps = MAX_JUMPS
		if Input.is_action_just_pressed("ui_up") and (jumps > 0 or nextToWall()):
			
			
			
			if not is_on_floor() and nextToRightWall():
				motion.x -= wallJump
				motion.y = -jumpWall
				
			elif (not is_on_floor() and nextToLeftWall()):
				motion.x += wallJump
				motion.y = -jumpWall
			else:
				motion.y = JUMP
				jumps -= 1
		if nextToWall() and motion.y > MAX_SPEED / 2:
			motion.y = MAX_SPEED / 2
		if friction == true:
			motion.x = lerp(motion.x, 0,1);

	else:
		if Input.is_action_just_pressed("ui_up") && jumps > 0:
			motion.y = JUMP * 0.75
			jumps -= 1
		if motion.y < 0 && jumps >= 1:
			$Sprite.play("Jump")
		elif motion.y < 0 && jumps ==0:
			$Sprite.play("Jump2")
		else:
			$Sprite.play("Fall")
		if friction == true:
			motion. x = lerp(motion.x, 0, 0.5)
	motion = move_and_slide(motion, UP)
	
	pass

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()

func respawn():
	get_tree().reload_current_scene()
