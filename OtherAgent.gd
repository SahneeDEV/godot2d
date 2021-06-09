
extends Sprite

export var speed = 200
const eps = 1.5
var points = []

func _ready():
	set_process(true)

func _process(delta):
	var cpos = global_position
	points = get_node("../Navigation2D").get_simple_path(cpos, get_global_mouse_position(), true)
	if points.size() > 1:
		var p = points[1]
		var dist = cpos.distance_to(p)
		var next_pos = cpos.linear_interpolate(p, speed * delta / dist)
		print("cpos is " + String(cpos))
		print("p is " + String(p))
		print("next_pos is " + String(next_pos))
		print(" ---- ")
		global_position = next_pos
	update()

func _draw():
	for p in points:
		draw_circle(to_local(p), 25, Color(1, 0, 0))
