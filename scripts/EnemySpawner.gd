extends CanvasItem
class_name EnemySpawner

export(Array, PackedScene) var enemies = []
export var speed_multiplier = Vector2(0.5, 1.5)
export var show_flow = false

onready var default_font = Control.new().get_font("font")
onready var flow_field = get_tree().get_root().get_node("/root/World/FlowField")
onready var tower_manager = get_tree().get_root().get_node("/root/World/TowerManager")

# the flow field used by this spawner
var flow: Dictionary = {}
# all currently living enemies of this spawner
var instances: Array = []
# rng for this spawner
var rng = RandomNumberGenerator.new()
# how many enemies left to spawn
var amount_to_spawn: int = 0

# spawned all enemies to be spawned
signal spawning_finished()
# started spawning
signal spawning_started()
# all spawned enemies have left the map
signal spawning_cleared()

func _ready():
	$Timer.stop()
	rng.randomize()
	flow_field.connect("grid_changed", self, "_on_grid_changed")

func _on_timer():
	var enemy = enemies[randi() % enemies.size()]
	var instance: Enemy = enemy.instance()
	var pos = $Location.global_position
	instance.global_position = pos
	add_child(instance)
	instance.flow = flow
	if show_flow:
		instance.draw_path = show_flow
	instances.push_back(instance)
	instance.connect("tree_exiting", self, "_on_tree_exiting", [instance])
	instance.connect("enemy_defeated", self, "_on_enemy_defeated", [instance])
	randomize_speed(instance)
	amount_to_spawn = amount_to_spawn - 1
	if amount_to_spawn == 0:
		emit_signal("spawning_finished")
		$Timer.stop()

# starts spawning
func spawn(amount: int):
	amount_to_spawn = amount
	$Timer.start()
	emit_signal("spawning_started")

func randomize_speed(instance):
	var speed = instance.speed
	speed = rng.randf_range(speed * speed_multiplier.x, speed * speed_multiplier.y)
	instance.speed = speed

func rebuild_flow():
	flow = flow_field.path_to_world($Target.global_position.floor())
	print("[EnemySpawner] Created new flow field to " + String($Target.name))
	if show_flow:
		update()
	# update paths of existing enemies
	for instance in instances:
		instance.flow = flow

func _on_grid_changed():
	rebuild_flow()

func _draw():
	if show_flow:
		for node in flow.field:
			var color = Color(0, 0, 0)
			var pos = Vector2(node.x * flow.cell_size + flow.cell_size / 2, node.y * flow.cell_size + flow.cell_size / 2)
			draw_string(default_font, pos, "Cost: " + String(node.cost))
			draw_string(default_font, pos + Vector2(0, 16), "Dir: " + String(node.direction))
			draw_line(pos, pos + node.direction * flow.cell_size / 2.5, color)
			draw_circle(pos + node.direction * flow.cell_size / 2.5, 5, color)

# called when an enemy has been defeated
func _on_enemy_defeated(instance: Enemy):
	var reward = instance.reward_money
	tower_manager.money += reward

# called when an enemy gets deleted from the game world
func _on_tree_exiting(instance: Enemy):
	var idx = instances.find(instance)
	if idx != -1:
		instances.remove(idx)
	if instances.size() == 0 && amount_to_spawn == 0:
		emit_signal("spawning_cleared")
