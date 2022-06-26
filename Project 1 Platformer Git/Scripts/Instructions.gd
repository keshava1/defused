extends Node

#multiplayer instructions
export(bool) var mp = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if(PlayerVars.hardMode == true):
		queue_free()
	if(mp == true):
		if(PlayerVars.twoP != true):
			print("hello")
			queue_free()
	self.z_index = -1



