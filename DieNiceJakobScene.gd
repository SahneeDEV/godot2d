extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Node2D = $Zoombie

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	var new_path : = nav_2d.get_simple_path(character.global_position, get_global_mouse_position())
	line_2d.points = new_path
	character.path = new_path

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
