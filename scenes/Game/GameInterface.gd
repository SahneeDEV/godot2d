extends Control

# all buildable towers
onready var tower_button_scene = preload("res://scenes/Game/TowerButton.tscn")
onready var tower_manager = get_node("/root/World/TowerManager")

func _ready():
	for tower in tower_manager.towers:
		var instance = tower_button_scene.instance()
		var ti = tower.instance()
		instance.get_node("Label").text = ti.tower_name + "\n(" + str(ti.build_price) + ")"
		instance.connect("pressed", self, "_on_tower_button_pressed", [tower])
		$Bottom/Container.add_child(instance)

func _on_tower_button_pressed(tower):
	tower_manager.selected_tower = tower
