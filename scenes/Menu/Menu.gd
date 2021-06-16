extends Control

func _ready():
	for button in $Margin/Container/Buttons/VBoxContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button])

func _on_Button_pressed(button):
	var button_target_scene = button.get("button_target_scene")
	if button_target_scene != null:
		get_tree().change_scene_to(button_target_scene)
