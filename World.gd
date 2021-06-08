extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
onready var line_2d: Line2D = $Line2D
onready var agent: Sprite = $PathAgent

func _unhandled_input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	var mpos = get_global_mouse_position()
	print("mpos            : " + String(mpos))
	print("global_position : " + String(event.global_position))
	print(" --- ")
#	print(String(mpos))
	var new_path := nav_2d.get_simple_path(agent.global_position, mpos)
	line_2d.points = new_path
	agent.path = new_path
