extends RigidBody2D
class_name Enemy

# The health of the enemy
export var hp : float = 200
#The max health the enemy has got
# The move speed
export var speed = 175
# The distance to the target at which to stop moving
export var eps = 10
# Draw the path using debug dots
export var draw_path = false

var target := Vector2(0, 0) setget set_target
var points = []
var max_hp : float = 0

var bar_green = preload("res://images/characters/healthbars/Bar_Green_Front.png")
var bar_yellow = preload("res://images/characters/healthbars/Bar_Yellow_Front.png")
var bar_red = preload("res://images/characters/healthbars/Bar_Red_Front.png")

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

func _process(delta):
	var cpos = global_position
	if points.size() > 0:
		var p = points[0]
		var dist = cpos.distance_to(p)
		if dist < eps:
			points.remove(0)
		if dist == 0:
			return
		var next_pos = cpos.linear_interpolate(p, speed * delta / dist)
		global_position = next_pos
	if hp <= 0:
		queue_free()
	if draw_path:
		update()

func _draw():
	if draw_path:
		for p in points:
			draw_circle(to_local(p), 25, Color(1, 0, 0))
			
func apply_damage(to: Base):
	to.take_damage(ceil(hp / 10))
	queue_free()
			
func take_damage(damage):
	hp -= damage
	set_healthbar_progress()
	print(self.name + " took damage! " + String(hp))
	
func is_tower_target(tower):
	return true

func set_target(new_target):
	target = new_target
	var nav2d = get_nav2d()
	var cpos = global_position
	points = nav2d.get_simple_path(cpos, target, true)

func get_nav2d():
	return  get_tree().get_root().get_node("./World/Navigation2D")
