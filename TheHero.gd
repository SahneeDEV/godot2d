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
			
	if vel.length() > 0:
	   vel = vel.normalized() * speed
	else:
		if Input.is_action_pressed("shoot"):
			_animated_sprite.play("shoot")
		else:
			_animated_sprite.play("idle")

	position += vel * delta
	
