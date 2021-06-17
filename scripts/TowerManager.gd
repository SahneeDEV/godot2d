extends Node2D
class_name TowerManager

# all towers available for construction
export(Array, PackedScene) var towers = []
# the player money
export var money = 200 setget _set_money

# the tower selected for construction
var selected_tower: PackedScene = null
# all towers in the world
var placed_towers = {}

# the tilemap node
onready var tilemap: TileMap = get_node("/root/World/TileMap")
onready var money_gui: Label = get_node("/root/World/GUI/GameInterface/Money/Label")
onready var toasts: ToastManager = get_node("/root/World/GUI/GameInterface/ToastManager")

# called when a tower is placed
signal tower_placed(tower)

func _ready():
	self.money = money
	set_process(true)

func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT && selected_tower != null:
		var pos = get_global_mouse_position()
		spawn_tower(pos)
		
func spawn_tower(pos):
	var gpos = snap_to_tile_map(pos)
	var mpos = map_position(gpos)
	var instance = selected_tower.instance()
	if !can_afford(instance):
		toasts.show_toast("Cannot affort this tower. You are missing " + str(instance.build_price - money) + " money.", Color(1, 0, 0))
		instance.queue_free()
		return
	if !is_placeable(instance, mpos, gpos, placed_towers.get(mpos), null):
		toasts.show_toast("Cannot place on tower on this tile.", Color(1, 0, 0))
		instance.queue_free()
		return
	add_child(instance)
	instance.global_position = gpos
	var placed_tower = {
		"map_position": mpos,
		"global_position": gpos,
		"instance": instance,
	}
	placed_towers[mpos] = placed_tower
	var build_sound = instance.get_node("./BuildSound")
	if build_sound != null:
		build_sound.play()
	self.money -= instance.build_price
	emit_signal("tower_placed", placed_tower)
		
func can_afford(tower):
	return money >= tower.build_price
			
func map_position(global_position):
	var local_position = tilemap.to_local(global_position)
	var map_position = tilemap.world_to_map(local_position)
	return map_position

func snap_to_tile_map(pos):
	var cs = tilemap.cell_size
	return Vector2(floor(pos.x / cs.x) * cs.x + cs.x / 2, floor(pos.y / cs.y) * cs.y + cs.y / 2)
	
func is_placeable(tower, map_position, global_position, current_state, cell):
	return tower.is_placeable(tower, map_position, global_position, current_state, cell)

func _set_money(new_money):
	money = new_money
	money_gui.text = str(money)
	
