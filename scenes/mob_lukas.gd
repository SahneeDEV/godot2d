extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed : = int() setget set_speed
var path : = PoolVector2Array() setget set_path
var destination = Vector2()
var health : = float() setget set_health

signal mob_defeated

func set_skin():
	if health == 1:
		$mob1.visible = false
		$mob0.visible = true
	if health == 2:
		$mob1.visible = true
		$mob0.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_skin()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if path.size() > 0:
		#move along the path
		var distance = speed * delta
		move_along_path(distance)
	elif abs(position.x - destination.x) < 10 and abs(position.y - destination.y) < 10:
		#free mob
		queue_free()

func move_along_path(distance):
	var start_pos = position
	for i in range(path.size()):
		var distance_to_next = start_pos.distance_to(path[0])
		if distance <= distance_to_next and distance > 0:
			position = start_pos.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance <= 0:
			position = path[0]
			break
		
		distance -= distance_to_next
		start_pos = path[0]
		path.remove(0)

func set_path(new_path):
	#path is set in the main script
	path = new_path

func set_speed(new_speed):
	speed = new_speed
	
func set_health(new_health):
	health = new_health

func take_damage(damage):
	health -= damage
	if health <= 0:
		$hit.play()
		emit_signal("mob_defeated")
		queue_free()
