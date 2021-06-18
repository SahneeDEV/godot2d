extends Button

var next_scene = ""


func _ready():
	var level = get_node("/root/World").game_level
	next_scene = "res://scenes/Game/Levels/Level" + str(level + 1) + ".tscn"
	visible = ResourceLoader.exists(next_scene)
	print("[NextLevelButton] Next level is " + next_scene + " which exists? " + str(visible))
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	get_tree().change_scene(next_scene)
