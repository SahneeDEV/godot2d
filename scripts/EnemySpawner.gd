extends Node
class_name EnemySpawner

export(Array, PackedScene) var enemies = []
export var speed_multiplier = Vector2(0.5, 1.5)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _on_timer():
	var enemy = enemies[randi() % enemies.size()]
	var instance = enemy.instance()
	var pos = $Location.global_position
	instance.global_position = pos
	add_child(instance)
	instance.target = $Target.global_position
	randomize_speed(instance)
	
func randomize_speed(instance):
	var speed = instance.speed
	speed = rng.randf_range(speed * speed_multiplier.x, speed * speed_multiplier.y)
	instance.speed = speed
	
