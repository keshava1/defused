extends Node2D


export(String, MULTILINE) var text

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tooltip/NinePatchRect/MarginContainer/VBoxContainer/Label.text = text
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Area2D_mouse_entered():
	if $Tooltip.visible == false:
		$Tooltip.visible = true
	print("enter")





func _on_Area2D_mouse_exited():
	if$Tooltip.visible == true:
		$Tooltip.visible = false
	print("exit")
