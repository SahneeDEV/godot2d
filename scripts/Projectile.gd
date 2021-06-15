extends RigidBody2D
class_name Projectile

# the move speed of the projectile
export var speed = 750
# how long may this projectile exist before despawning
export var max_age = 5000
# the damage this projectile deals
export var damage = 50

# TODO: Homing
# TODO: Deteriorate damage over time (do it in take_damage calc)

# the location we are shooting
var target: Vector2 = Vector2(0, 0)
# how long does this projectile already exist?
var age = 0

func _ready():
	connect("body_entered", self, "_on_body_entered")
	contact_monitor = true
	contacts_reported = 1
	set_process(true)
	
func _process(delta):
	# move
	var linearVelocityModule = -speed
	var anglePlayerRot = rotation
	var localLinearVelocityX = linearVelocityModule * cos (anglePlayerRot)
	var localLinearVelocityY = linearVelocityModule * sin (anglePlayerRot)
	linear_velocity = Vector2(localLinearVelocityX, localLinearVelocityY)
	# Age
	age += delta
	#applied_force = Vector2(speed, 0)
	if age > max_age:
		queue_free()
		
func _on_body_entered(node):
	print("[Projectile] " + name + " hit target " + node.name)
	if node.has_method("take_damage"):
		node.take_damage(damage)
	queue_free()

#func _physics_process(delta):
#	position += transform.x * speed * delta
