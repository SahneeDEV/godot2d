extends Node2D
class_name TowerManager

export(Array, PackedScene) var towers = []

onready var tilemap = get_node("/root/World/TileMap")

var placed_towers = {}

signal tower_placed(tower)

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
		var placed_tower = {
			"map_position": mpos,
			"global_position": gpos,
			"instance": instance,
		}
		placed_towers[mpos] = placed_tower
		var build_sound = instance.get_node("./BuildSound")
		if build_sound != null:
			build_sound.play()
		emit_signal("tower_placed", placed_tower)
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
