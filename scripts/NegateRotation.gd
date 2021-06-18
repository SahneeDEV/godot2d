extends Node2D

func _ready():
	set_process(true)

func _process(_delta):
	var rot = get_node("..").get_global_transform().get_rotation()
	rotation = -rot
