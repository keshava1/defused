extends Sprite



# Called when the node enters the scene tree for the first time.
func _ready():
	# 1 is initial val, 0 is final val, 1 is time it takes, 3 is transition type, 1 is ease type
	# interpolates color to be more opaque
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1, 3, 1)
	$Tween.start()





func _on_Tween_tween_completed(object, key):
	#delete node
	queue_free()


