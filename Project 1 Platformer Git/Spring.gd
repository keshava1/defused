extends Area2D


#func _physics_process(delta):
#	var bodies = get_overlapping_bodies()
#	for body in bodies:
#		if body.name == "Player":
			#play animation
			#yeild untill "animation_finished"
#		else:
			#play idle
			
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			PlayerVars.motion.y = PlayerVars.SPRING
