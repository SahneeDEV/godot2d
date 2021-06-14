extends Node
class_name EnemySpawner

export(Array, PackedScene) var enemies = []
export var speed_multiplier = Vector2(0.5, 1.5)

onready var flow_field = get_tree().get_root().get_node("/root/World/FlowField")
var flow = []

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	flow_field.connect("grid_changed", self, "_on_grid_changed")

func _on_timer():
	var enemy = enemies[randi() % enemies.size()]
	var instance = enemy.instance()
	var pos = $Location.global_position
	instance.global_position = pos
	add_child(instance)
	instance.flow = flow
	randomize_speed(instance)
	
func randomize_speed(instance):
	var speed = instance.speed
	speed = rng.randf_range(speed * speed_multiplier.x, speed * speed_multiplier.y)
	instance.speed = speed
	
func _on_grid_changed():
	flow = flow_field.path_to_world($Target.global_position.floor())
	print("[EnemySpawner] Created new flow field to " + String($Target.name))
