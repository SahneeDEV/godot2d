extends Node
class_name EnemySpawner

export(Array, PackedScene) var enemies = []

func _ready():
	pass

func _on_timer():
	var enemy = enemies[randi() % enemies.size()]
	var instance = enemy.instance()
	var pos = $Location.global_position
	instance.global_position = pos
	add_child(instance)
	instance.target = $Target.global_position
