extends Sprite

var speed := 400.0
var path := PoolVector2Array() setget set_path

func _ready():
	set_process(false)
	
func _process(delta):
	var dist = speed * delta
	move_along_path(dist)
	
func move_along_path(dist: float):
	var start_point := position
	for i in range(path.size()):
		var dist_to_next = start_point.distance_to(path[0])
		if dist <= dist_to_next and dist >= 0.0:
			position = start_point.linear_interpolate(path[0], dist / dist_to_next)
			break
		elif dist < 0.0:
			position = path[0]
			set_process(false)
			break
		dist -= dist_to_next
		start_point = path[0]
		path.remove(0)

func set_path(points: PoolVector2Array):
	path = points
	if points.size() == 0:
		return
	set_process(true)
