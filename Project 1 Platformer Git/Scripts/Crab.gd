extends KinematicBody2D


const GRAVITY = 10
const SPEED = 60
const FLOOR = Vector2(0,-1)
const HEIGHT = 750
var velocity = Vector2()
var direction = 1
var dying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(PlayerVars.twoP == false):
		queue_free()
	$S.play("vibing")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(dying == false):
		velocity.x = SPEED * direction
		if(direction == 1):
			$S.flip_h = true
		else:
			$S.flip_h = false
		
		
		velocity.y += GRAVITY

		velocity = move_and_slide(velocity, FLOOR)

		if(is_on_wall()):
			direction = direction * -1
			$raycast.position.x *= -1
		if($raycast.is_colliding() == false):
			print("turned")
			direction = direction * -1
			$raycast.position.x *= -1
			


func _on_A_input_event(viewport, event, shape_idx):
	
	if(event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()):
		if(PlayerVars.hardMode == true):
			PlayerVars.fuseAdd = -5
		death()
func death():
	print("clicked2")
	dying = true
	$C.disabled = true
	$S.play("death")
	yield($S, "animation_finished")
	queue_free()


func _on_A_body_entered(body):
	if(body.name == "Player" and dying == false):
		body.respawn()
