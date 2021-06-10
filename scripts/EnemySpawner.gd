extends Node

export(Array, PackedScene) var enemies = []

func _ready():
	pass

func _on_timer():
#	print("on timer")
	var enemy = enemies[randi() % enemies.size()]
	var instance = enemy.instance()
#	print("instance" + instance.name)
	var pos = $Location.global_position
#	print("pos" + String(pos))
	instance.global_position = pos
	add_child(instance)
	instance.target = $Target.global_position
