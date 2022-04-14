extends Area2D

#export var springDirection : int
export(int) var springDirection = 0
#func _physics_process(delta):
#	var bodies = get_overlapping_bodies()
#	for body in bodies:
#		if body.name == "Player":
			#play animation
			#yeild untill "animation_finished"
#		else:
			#play idle
			
func _ready():
	if(springDirection == 1):
		$Sprite.rotate(PI)
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			PlayerVars.jumps = 1
			if(springDirection == 0):
				PlayerVars.motion.y = PlayerVars.SPRING
			if(springDirection == 1):
				PlayerVars.motion.y = -PlayerVars.SPRING
			PlayerVars.canDash = true
			$Sprite.play("Spring")


func _on_Sprite_animation_finished():
	$Sprite.play("Idle")
