extends Node2D


# Declare member variables here. Examples:
#
var speed = 150

# Called when the node enters the scene tree for the first time.
func _process(delta):
  move_local_x(speed*delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
