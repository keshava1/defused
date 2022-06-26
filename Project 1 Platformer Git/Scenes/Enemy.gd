extends KinematicBody2D

const GRAVITY = 10
const SPEED = 60
const FLOOR = Vector2(0,-1)
const HEIGHT = 750
var velocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("dinowalk")

func _physics_process(delta):
	velocity.x = SPEED * direction
	if(direction == 1):
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	$AnimatedSprite.play("dinowalk")
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	if(is_on_wall()):
		direction = direction * -1
		$raycast.position.x *= -1
	if($raycast.is_colliding() == false):
		direction = direction * -1
		$raycast.position.x *= -1
		
	var bodies = $Head.get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			#if(PlayerVars.hardMode == true):
			#	body.deathTimerAdd(25)
			queue_free()
			PlayerVars.motion.y -= HEIGHT
			PlayerVars.canDash = true
			PlayerVars.jumps = 1
	


func _on_Body_body_entered(body):
	if(body.name == "Player"):
		body.respawn()

