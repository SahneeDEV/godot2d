extends Control

export(Array, PackedScene) var levels

onready var start_game_button = preload("res://scenes/Menu/StartGameButton.tscn")
onready var container = $Margin/Container/Buttons/VBoxContainer

func _ready():
	add_level_btns()
	for button in container.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button])

func _on_Button_pressed(button):
	var button_target_scene = button.get("button_target_scene")
	if button_target_scene != null:
		get_tree().change_scene_to(button_target_scene)

func add_level_btns():
	var save = Save.new()
	save.load_data()
	var num = 0
	for level in levels:
		num += 1;
		var prev = float(num - 1)
		var show = true if num == 1 else save.data.levels.find(prev) != -1
		print("[Menu] Showing level " + str(num) + "? " + str(show))
		if show:
			var instance: MenuSceneButton = start_game_button.instance()
			instance.button_target_scene = level
			instance.get_node("./Label").text = "Play Level " + str(num)
			container.add_child(instance)
