extends Node2D
class_name TowerManager

export var towers = [preload("res://towers/Tower_Crossbow.tscn")]

onready var nav2d = get_node("/root/World/Navigation2D")
onready var tilemap = nav2d.get_node("./TileMap")

var placed_towers = {}

func _ready():
	set_process(true)

func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		var pos = get_global_mouse_position()
		spawn_tower(pos)
		
func spawn_tower(pos):
	var gpos = snap_to_tile_map(pos)
	var mpos = map_position(gpos)
	var instance = towers[0].instance()
	if is_placeable(instance, mpos, gpos, placed_towers.get(mpos), null):
		add_child(instance)
		instance.global_position = gpos
		placed_towers[mpos] = {
			"map_position": mpos,
			"global_position": gpos,
			"instance": instance,
		}
		var build_sound = instance.get_node("./BuildSound")
		if build_sound != null:
			build_sound.play()
	else:
		instance.queue_free()
			
func map_position(global_position):
	var local_position = tilemap.to_local(global_position)
	var map_position = tilemap.world_to_map(local_position)
	return map_position

func snap_to_tile_map(pos):
	var cs = tilemap.cell_size
	return Vector2(floor(pos.x / cs.x) * cs.x + cs.x / 2, floor(pos.y / cs.y) * cs.y + cs.y / 2)
	
func is_placeable(tower, map_position, global_position, current_state, cell):
	return tower.is_placeable(tower, map_position, global_position, current_state, cell)

func cutout(pos):
	var newpolygon = PoolVector2Array()
	var polygon = "ok"
