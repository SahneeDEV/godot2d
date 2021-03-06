extends RigidBody2D
class_name Enemy

# The health of the enemy
export var hp: float = 200
# The move speed
export var speed = 175
# The distance to the target at which to stop moving
export var eps = 10
# Draw the path using debug dots
export var draw_path = false
# The max force of the enemy
export var max_force = 175
# how much money the player gets for defeating this enemy
export var reward_money = 10

# the main game tilemap
onready var tile_map = get_tree().get_root().get_node("/root/World/TileMap")

# the flow field the enemy follows
var flow = null
# The max health the enemy has got
var max_hp: float = 0

var bar_green = preload("res://images/characters/healthbars/Bar_Green_Front.png")
var bar_yellow = preload("res://images/characters/healthbars/Bar_Yellow_Front.png")
var bar_red = preload("res://images/characters/healthbars/Bar_Red_Front.png")

signal enemy_defeated()

onready var healthbar = $Health/TextureProgress

func _ready():
	set_process(true)
	#preserve the max hp of the enemy
	max_hp = hp
	
func set_healthbar_progress():
	var hp_value = (hp / max_hp) * 100
	healthbar.texture_progress = bar_green
	if hp_value < 75:
		healthbar.texture_progress = bar_yellow
	if hp_value < 35:
		healthbar.texture_progress = bar_red
	healthbar.value = hp_value

func _process(_delta):
	var data = flow_data()
	if data != null:
		var desired = data.node.direction * speed
		var steer = (desired - linear_velocity).clamped(max_force)
		apply_impulse(Vector2(0, 0), steer)
	if hp <= 0:
		$Hurt.stop()
		$Defeated.play()
		emit_signal("enemy_defeated")
		queue_free()
	if draw_path:
		update()

func _draw():
	if draw_path:
		var data = flow_data()
		if data != null:
			var color = Color(1, 0, 0)
			draw_circle(to_local(data.map_pos * flow.cell_size), 10, color)

func flow_data():
	var world_pos = global_position
	var map_pos = tile_map.world_to_map(world_pos)
	var idx = int(map_pos.x * flow.size + map_pos.y)
	if idx < flow.field.size() && idx >= 0:
		var node = flow.field[idx]
		return {
			"node": node,
			"world_pos": world_pos,
			"map_pos": map_pos,
			"i": idx,
		}
	return null
			
func apply_damage(to: Base):
	to.take_damage(ceil(hp / 10))
	queue_free()
			
func take_damage(damage):
	hp -= damage
	if !$Hurt.playing && !$Defeated.playing:
		$Hurt.play()
	set_healthbar_progress()
	print("[Enemy] " + self.name + " took damage! " + String(hp))
	
func is_tower_target(_tower):
	return true
