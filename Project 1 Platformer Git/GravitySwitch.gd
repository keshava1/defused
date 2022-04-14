extends Area2D

export var gravityDirection : int

func _ready():
	if(gravityDirection == 0):
		rotate(0)
	if (gravityDirection == 1):
		rotate(PI)
	$AnimatedSprite.play("default")
func _on_GravitySwitch_body_entered(body):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			PlayerVars.canDash = true
			PlayerVars.jumps = 1
			swapDirection()
			#$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2, 1, 1)
			
		
func swapDirection():
	# down gravity
	if(gravityDirection == 0 and PlayerVars.vFlip == true):
		PlayerVars.downGravity()
		#queue_free()
	# upwards gravity
	if(gravityDirection == 1 and PlayerVars.vFlip == false):
		PlayerVars.upGravity()
		#queue_free()
