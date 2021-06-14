extends RigidBody2D
class_name Enemy

# The health of the enemy
export var hp = 200
# The move speed
export var speed = 175
# The distance to the target at which to stop moving
export var eps = 10
# Draw the path using debug dots
export var draw_path = false

var target := Vector2(0, 0) setget set_target
var points = []

func _ready():
	set_process(true)

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

