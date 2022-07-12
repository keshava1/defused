extends KinematicBody2D


# costants for method
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
var started
#var time_elapsed = PlayerVars.timer

export(PackedScene) var foot_step
var last_step = 0

#export deth min and death max that can depend based on the level if player falls off
export(int) var DEATH_MIN = 1000
export(int) var DEATH_MAX = -2000

# dash variables
var dashDir = Vector2(1,0)
var canDash = false;
var dashing = false

func _ready():
	print(PlayerVars.hardMode)
	if(PlayerVars.hardMode == true):
		$UI/Control/BarTimer.start()
		$UI/Control/Spark.position = $UI/Control/ProgressBar.get_rect().position
		$UI/Control/Spark.position.y += 9
		print("hard mode")
	else:
		$UI/Control.visible = false
		print("hidden bar")
		$UI/Control.queue_free()
	print("ready")
	started = false
	$Sprite.play("Idle")
	$Explosion.play("Blank")
	$deathTween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,0,0,1), 0.125, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if(PlayerVars.muted == false):
		MusicPlayer.stream_paused = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(PlayerVars.dying == true):
		return
	update_dash()
	if(started):
		update_timer(delta)
	#update fuse for crabs in hardmode
	if(PlayerVars.hardMode == true and PlayerVars.fuseAdd != 0):
		deathTimerAdd(PlayerVars.fuseAdd)
		PlayerVars.fuseAdd = 0
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
	$Sprite.offset.y = PlayerVars.offset
	# move left and right
	if Input.is_action_pressed("ui_right"):
		
		started = true
		
		if(dashing == false):
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
		

	elif Input.is_action_pressed("ui_left"):
		
		started = true
		
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
			motion.x = lerp(motion.x, 0,0.1);
		# jump code
		if Input.is_action_just_pressed("ui_up") and (jumps > 0 or nextToWall()):
			started = true
			
			# wall jumps
			if (not is_on_floor()) and nextToRightWall():
				motion.x = -PlayerVars.walljumpx
				motion.y = -PlayerVars.wallJumpY
				#print(PlayerVars.wallJumpY)
			elif (not is_on_floor()) and nextToLeftWall():
				motion.x = PlayerVars.walljumpx
				motion.y = -PlayerVars.wallJumpY
				#print(PlayerVars.wallJumpY)
			# else, do a normal jump
			else:
				motion.y = PlayerVars.jump
				jumps -= 1
		# Wall slide
		if nextToWall() and motion.y > MAX_SPEED / 2 and PlayerVars.vFlip == false:
			motion.y = MAX_SPEED / 2
			$Sprite.play("WallSlide")
		if nextToWall() and motion.y < MAX_SPEED / 2 and PlayerVars.vFlip == true:
			motion.y = -MAX_SPEED / 2
			$Sprite.play("WallSlide")

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
			motion. x = lerp(motion.x, 0, 0.025)
	# start dash and particles, move, then update PlayerVars
	dash()
	particles()
	motion = move_and_slide(motion, PlayerVars.direction)
	PlayerVars.canDash = canDash
	PlayerVars.motion = motion
	PlayerVars.jumps = jumps
#for walljump, if player is next to any wall
func nextToWall():
	return nextToRightWall() or nextToLeftWall()
#for wall jump, if player is next to right wall
func nextToRightWall():
	return $RightWall.is_colliding()
#for walljump, if the player is next to left wall
func nextToLeftWall():
	return $LeftWall.is_colliding()
#respawns the player
func respawn():
	PlayerVars.dying = true
	print("respawn")
	$deathTween.start()
	yield($deathTween, "tween_completed")
	$Sprite.play("Blank")
	$Explosion.play("Explosion")
	yield($Explosion, "animation_finished")
	$Explosion.play("Blank")
	PlayerVars.deaths += 1
	PlayerVars.reset()
	canDash = PlayerVars.canDash
	motion = PlayerVars.motion
	jumps = PlayerVars.jumps
	PlayerVars.dying = false
	#if(PlayerVars.hardMode == true):
	#	get_tree().change_scene("res://Scenes/World7.tscn")
	#else:
	get_tree().reload_current_scene()
	
# preload the dash scene
var ghost_scene = preload("res://Scenes/DashGhost.tscn")

#function to have the player dash forward
func dash():
	# dashing allowed if is on floor
	if(is_on_floor()):
		canDash = true
	if(Input.is_action_pressed("ui_right")): #direction of the dash
		dashDir = Vector2(1, 0)
	if(Input.is_action_pressed("ui_left")):
		dashDir = Vector2(-1, 0)
	if(Input.is_action_just_pressed("ui_dash") and canDash): # if dashing is allowed:
		#set up timer for dash reset
		var ghost_timer = $GhostTimer
		ghost_timer.start()
		ghost_timer.connect("timeout", self, "_on_Timer_timeout")
		# add to motion and reset vars
		motion = dashDir.normalized() * DASH_LENGTH
		dashing = true
		canDash = false
		#use instance ghost method
		instance_ghost($Sprite)
		#wait for timer to finish
		yield(get_tree().create_timer(0.2), "timeout")
		#turn of dashing, stop motion, end ghost timer
		dashing = false
		PlayerVars.motion.x = 0
		ghost_timer.stop()
		
#for the dash to have ghost effects behind it
func instance_ghost(sprite):
	var ghost : Sprite = ghost_scene.instance() # create ghost scene
	get_parent().get_parent().add_child(ghost) # add ghost node
	#set ghost attributes
	ghost.global_position = sprite.global_position
	ghost.texture = sprite.get_sprite_frames().get_frame(sprite.animation,sprite.get_frame())
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.flip_v = sprite.flip_v
	ghost.scale = Vector2(0.233,0.233)
# instance ghost on timeout
func _on_Timer_timeout():
	instance_ghost($Sprite)
	
#updates the dash when the player touches the ground
func update_dash():
	if(PlayerVars.canDash):
		$UI/DashSprite.modulate = Color(1, 1, 1, 1)
	else:
		$UI/DashSprite.modulate = Color(1, 1, 1, 0.25)
#pdate the game timer
func update_timer(delta):
	#time_elapsed += delta
	PlayerVars.timer += delta
	$UI/Timer.text = str(stepify(PlayerVars.timer, 1))

#bar timer controls how fast the fuse slows down
func _on_BarTimer_timeout():
	if(started):
		#every time, subtract 1 from the prorgess bar and change the location of the spark
		$UI/Control/ProgressBar.value -= 1
		$UI/Control/Spark.position.x = $UI/Control/ProgressBar.get_rect().position.x + $UI/Control/ProgressBar.value * $UI/Control/ProgressBar.rect_size.x * 0.01
		$UI/Control/Spark.position.y = $UI/Control/ProgressBar.get_rect().position.y + 9
		#respawn when timer hits 0
		if($UI/Control/ProgressBar.value == 0):
			respawn()
#add or subtract a value to the death timer
func deathTimerAdd(value):
	print(PlayerVars.hardMode)
	if(PlayerVars.hardMode == true):
		$UI/Control/ProgressBar.value += value
		
#looks at player particle efffects
func particles():

	#if you are not moving, dont trigger effects
	if(motion == Vector2(0,0)):
		last_step = -1
	#if running, do particle effects on frames 0 and 8
	if$Sprite.animation == "Run" and is_on_floor():
		var f = $Sprite.frame
		if(f == 0 or f == 8):
			#makes sure particle effects dont trigger on slowdown
			if(last_step != $Sprite.frame):
				last_step = $Sprite.frame
				var step = foot_step.instance()
				step.emitting = true
				step.global_position = Vector2(global_position)
				#if the player is upside down
				if(PlayerVars.vFlip == true):
					step.global_position.y -=35
					step.process_material.direction.y = 1
				else:
					step.global_position.y += 30
					step.process_material.direction.y = -1
				#add particle scene
				get_parent().add_child(step)
			
