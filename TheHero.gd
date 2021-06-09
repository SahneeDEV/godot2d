extends KinematicBody2D

var speed = 250
var vel = Vector2()
onready var _animated_sprite = $AnimatedSprite
export (PackedScene) var Bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("shoot"):
		_animated_sprite.play("shoot")
	
	vel = Vector2() #set vel to Vector2(0, 0)
	if Input.is_key_pressed(KEY_RIGHT): # detecting right key
		_animated_sprite.play("run")
		vel.x += 1
	if Input.is_key_pressed(KEY_LEFT): # detecting right key
		_animated_sprite.play("run")
		vel.x -= 1
	if Input.is_key_pressed(KEY_UP): # detecting right key
		_animated_sprite.play("run")
		vel.y -= 1
	if Input.is_key_pressed(KEY_DOWN): # detecting right key
		_animated_sprite.play("run")
		vel.y += 1
		
	if vel.length() > 0:
	   vel = vel.normalized() * speed
	else:
		_animated_sprite.play("idle")

	position += vel * delta
	
