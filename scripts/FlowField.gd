extends Node

onready var tile_map = get_tree().get_root().get_node("/root/World/Navigation2D/TileMap")

const GRID_PASSABLE = 1;
const GRID_IMPASSABLE = 255;

const INTEGRATION_DEFAULT = 65525;
const INTEGRATION_START = 0;

const FLOW_DEFAULT = 9223372036854775807;

signal grid_changed

# the grid size
var size: int = 0
# the current grid
var grid = []
# all diections
var directions = [
	Vector2(0, 0),
	Vector2(0, 1),
	Vector2(1, 1),
	Vector2(1, 0),
	Vector2(0, -1),
	Vector2(-1, -1),
	Vector2(-1, 0),
	Vector2(-1, 1),
	Vector2(1, -1),
]

func _ready():
	rebuild_grid()
	
func rebuild_grid():
	print("[FlowField] Rebuilding grid with tile map " + tile_map.name)
	size = int(tile_map.cell_size.x)
	grid = []
	for x in size:
		for y in size:
			var i = idx_xy(x, y)
			var cell = tile_map.get_cell(x, y)
			var cell_autotile = tile_map.get_cell_autotile_coord(x, y)
			var cost = GRID_IMPASSABLE
			if cell != -1:
				var poly = tile_map.tile_set.autotile_get_navigation_polygon(cell, cell_autotile)
				if poly != null && poly.get_polygon_count() > 0:
					cost = GRID_PASSABLE
			grid.append({
				"i": i,
				"cost": cost,
				"x": x,
				"y": y,
			})
	print("[FlowField] Rebuilt grid")
	emit_signal("grid_changed")
		
# Gets the path to the given location.
func path_to_world(to):
	var map = tile_map.world_to_map(to)
	return path_to(map)
func path_to(to):
	var field = create_integration_field(int(to.x), int(to.y))
	field = create_flow_field(field)
	return {
		"field": field,
		"size": size,
		"to": to,
	}
	
func create_integration_field(x, y):
	print("[FlowField] Building integration field to " + String(x) + "/" + String(y))
	var to_i = idx_xy(x, y)
	var open_list = [to_i]
	var field = []
	for x in size:
		for y in size:
			var i = idx_xy(x, y)
			field.append({
				"i": i,
				"cost": INTEGRATION_DEFAULT,
				"direction": directions[0], # this one is technically part of the flow field, but we init it here for performance
				"x": x,
				"y": y,
			})			
	field[to_i].cost = INTEGRATION_START
	while open_list.size() > 0:
		var i = open_list.pop_front()
		var node = field[i]
		var end_node_cost = node.cost + grid[i].cost
		var neighbors = neighbors(field, i)
		for neighbor_i in neighbors:
			var neighbor = field[neighbor_i]
			if end_node_cost < neighbor.cost && grid[neighbor_i].cost < 255:
				if open_list.find(neighbor_i) == -1:
					open_list.push_back(neighbor_i)
				neighbor.cost = end_node_cost
	print("[FlowField] Integration field built")
	return field

func create_flow_field(field):
	print("[FlowField] Building flow field")
	for x in size:
		for y in size:
			var i = idx_xy(x, y)
			var node = field[i]
			var cheapest_dir = directions[0]
			var cheapest_cost = FLOW_DEFAULT
			for d in directions:
				if does_direction_lead_over_the_edge(x, y, d):
					continue
				var dir_i = idx_xy(x + d.x, y + d.y)
				var dir_node = field[dir_i]
				if dir_node.cost < cheapest_cost:
					cheapest_dir = d
					cheapest_cost = node.cost
			node.direction = cheapest_dir
	print("[FlowField] Flow field built")
	return field
	
# gets the indexes of the neighboring nodes
func neighbors(field, i):
	# math trick to get the x/y from the index
	var x = floor(i / size)
	var y = i % size
	var arr = []
	for d in directions:
		if does_direction_lead_over_the_edge(x, y, d):
			continue
		arr.push_back(idx_xy(x + d.x, y + d.y))
	return arr
	
# checks if going in the given direction at the current x/y will lead over the map edge
func does_direction_lead_over_the_edge(x, y, d):
	if d.x < 0 && x == 0:
		return true
	if d.x > 0 && x == size - 1:
		return true
	if d.y < 0 && y == 0:
		return true
	if d.y > 0 && y == size - 1:
		return true
	return false
	
# coordinates to index functions
func idx_xy(x, y):
	return int(x * size + y)
func idx_v2(v2):
	return int(v2.x * size + v2.y)
