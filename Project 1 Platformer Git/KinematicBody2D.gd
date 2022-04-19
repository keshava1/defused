extends KinematicBody2D

const UP = Vector2(0, -1)
#usually 275
const MAX_SPEED = 275
#usually 50
const ACCELERATION = 50
const MAX_JUMPS = 2
#var DEATH_MIN = 1000
#var DEATH_MAX = -2000
const SPRING = -1000
const DASH_LENGTH = 750
var jumps = MAX_JUMPS
var motion = Vector2()
var walljumpx = 400
var wallJumpY = 400
var time_elapsed = PlayerVars.timer

export(int) var DEATH_MIN = 1000
export(int) var DEATH_MAX = -2000
#Dash Vars

var dashDir = Vector2(1,0)
var canDash = false;
var dashing = false
func _ready():
	MusicPlayer.stream_paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_dash()
	update_timer(delta)
	# retrive playerVars
	canDash = PlayerVars.canDash
	motion = PlayerVars.motion
	jumps = PlayerVars.jumps
	# set friction and gravity
	$Sprite.flip_v = PlayerVars.vFlip
	if(!dashing):
		motion.y += PlayerVars.gravity
	var friction = false
	# fall death
	if get_position().y > DEATH_MIN or get_position().y < DEATH_MAX:
		respawn()
		
	# move left and right
	if Input.is_action_pressed("ui_right"):
		if(dashing == false):
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		if(dashing == false):
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	# if not moving friction is true
	else:
		friction = true
		$Sprite.play("Idle")
	#print(motion.x)
	if is_on_floor() or nextToWall():
		# reset jumps
		if is_on_floor():
			jumps = MAX_JUMPS
		# friction if player is on ground and not moving
		if friction == true and dashing == false:
			motion.x = lerp(motion.x, 0,0.2);
		# jump code
		if Input.is_action_just_pressed("ui_up") and (jumps > 0 or nextToWall()):
			# wall jumps
			if (not is_on_floor()) and nextToRightWall():
				motion.x = -PlayerVars.walljumpx
				motion.y = -PlayerVars.wallJumpY
				print(PlayerVars.wallJumpY)
			elif (not is_on_floor()) and nextToLeftWall():
				motion.x = PlayerVars.walljumpx
				motion.y = -PlayerVars.wallJumpY
				print(PlayerVars.wallJumpY)
			# else, do a normal jump
			else:
				motion.y = PlayerVars.jump
				jumps -= 1
		# Wall slide
		if nextToWall() and motion.y > MAX_SPEED / 2 and PlayerVars.vFlip == false:
			motion.y = MAX_SPEED / 2
		if nextToWall() and motion.y < MAX_SPEED / 2 and PlayerVars.vFlip == true:
			motion.y = -MAX_SPEED / 2

	else:
		# double jump fall animations
		if motion.y < 0 && jumps >= 1:
			$Sprite.play("Jump")
		elif motion.y < 0 && jumps ==0:
			$Sprite.play("Jump2")
		else:
			$Sprite.play("Fall")
		#double jump
		if Input.is_action_just_pressed("ui_up") and jumps > 0:
			#slight downward before jump
			move_and_slide(-motion * 0.1, PlayerVars.direction)
			yield(get_tree().create_timer(0.05), "timeout")
			motion.y = PlayerVars.jump * 0.85
			jumps -= 1

		# friction code (is player not pressing anything?)
		if friction == true and dashing == false:
			motion. x = lerp(motion.x, 0, 0.05)
	# move, then update PlayerVars
	dash()
	print(motion)
	#if(PlayerVars.live == true):
	motion = move_and_slide(motion, PlayerVars.direction)
	PlayerVars.canDash = canDash
	PlayerVars.motion = motion
	PlayerVars.jumps = jumps

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()

func respawn():
	#PlayerVars.live = false
	#$Sprite.play("Death")
	#yield(get_tree().create_timer(100.0), "timeout")
	PlayerVars.reset()
	canDash = PlayerVars.canDash
	motion = PlayerVars.motion
	jumps = PlayerVars.jumps
	get_tree().reload_current_scene()
	
	
var ghost_scene = preload("res://Scenes/DashGhost.tscn")

func dash():
	
	if(is_on_floor()):
		canDash = true
	if(Input.is_action_pressed("ui_right")):
		dashDir = Vector2(1, 0)
	if(Input.is_action_pressed("ui_left")):
		dashDir = Vector2(-1, 0)
	if(Input.is_action_just_pressed("ui_dash") and canDash):
		
		var ghost_timer = $GhostTimer
		ghost_timer.start()
		ghost_timer.connect("timeout", self, "_on_Timer_timeout")
		
		motion = dashDir.normalized() * DASH_LENGTH
		dashing = true
		canDash = false
		
		instance_ghost($Sprite)
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		dashing = false
		PlayerVars.motion.x = 0
		ghost_timer.stop()
		
func instance_ghost(sprite):
	var ghost : Sprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = sprite.global_position
	ghost.texture = sprite.get_sprite_frames().get_frame(sprite.animation,sprite.get_frame())
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.flip_v = sprite.flip_v
	ghost.scale = Vector2(1,1)
func _on_Timer_timeout():
	instance_ghost($Sprite)
	
func update_dash():
	if(PlayerVars.canDash):
		$UI/DashLabel.text = "Dash: Active"
	else:
		$UI/DashLabel.text = "Dash: Off"
func update_timer(delta):
	time_elapsed += delta
	PlayerVars.timer = time_elapsed
	$UI/Timer.text = str(stepify(time_elapsed, 0.01))
