extends Area2D


var original_pos: Vector2
var target_pos: Vector2
var velocity: Vector2
var speed = 800
var direction: Vector2
var damage = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	position = original_pos
	direction = target_pos - original_pos
	
	set_sprite_rotation()
	
	velocity = direction.normalized() * speed
	

func _physics_process(delta):

	position += velocity * delta

func set_sprite_rotation():
	var angle
	
	if direction.y != 0:
		angle = atan(direction.x / direction.y) * 180 / PI
	else:
		if direction.x > 0:
			angle = 90
		elif direction.x < 0:
			angle = 270
	
	if direction.x >= 0 and direction.y >= 0:
		#4th quadrant
		$sprite.rotation_degrees = 180 - angle
	elif direction.x >= 0 and direction.y <= 0:
		#1st quadrant
		$sprite.rotation_degrees = abs(angle)
	elif direction.x <= 0 and direction.y >= 0:
		#3rd quadrant
		$sprite.rotation_degrees = 180 + abs(angle)
	elif direction.x <= 0 and direction.y <= 0:
		#2nd quadrant
		$sprite.rotation_degrees = 360 - angle



func _on_projectile_area_entered(area):
	if "mob" in area.name:
		area.take_damage(damage)
		queue_free()
