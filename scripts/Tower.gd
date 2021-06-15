extends Node
class_name Tower

export var damage = 50
export var draw_target = false
export(PackedScene) var projectile = preload("res://projectiles/Projectile_Bullet.tscn")

var focus = null
var armed = true

func _ready():
	$Range.connect("body_exited", self, "_on_body_exited")
	$RearmTimer.connect("timeout", self, "_on_rearm")
	set_process(true)
	#hide tower border radius if forgotten
	$Range/CollisionShape2D/Sprite.visible = false;
	
func _input(event):
	#show tower range on right click
	if event.is_action_pressed("click_right"):
		#check that only the selected tower gets highlighted
		#var mouse_pos = $Tower_Crosssbow.get_local_mouse_position()
		#var baum = $Sprite.get_global_transform_with_canvas()
		#if mouse_pos.x > (baum.x + $Sprite.texture.get_size().x) :
		#	pass
		show_tower_range()

# Called every frame
func _process(delta):
	if !is_instance_valid(focus):
		find_new_focus()
	process_rotation(delta)
	process_shooting(delta)
	
# Called when the enemy leaves the range
func _on_body_exited(body):
	if body == focus:
		focus = null

# Called when the tower rearms
func _on_rearm():
	print("[Tower] " + self.name + " rearmed!")
	armed = true
	
## Can this tower be placed at the given location?
func is_placeable(tower, map_position, global_position, current_state, cell):
	return current_state == null

## Checks if the given body is a valid enemy for this tower.
func is_tower_target(body):
	return body.has_method("is_tower_target") && body.is_tower_target(self)

## Finds a free enemy in the tower range
func find_new_focus():
	for body in $Range.get_overlapping_bodies():
		if is_tower_target(body):
			focus = body
			print("[Tower] " + self.name + " acquired new target " + focus.name)
			return body

func process_rotation(delta):
	if !is_instance_valid(focus):
		return
	var degrees = rad2deg($Sprite.global_position.angle_to_point(focus.global_position))
	$Sprite.rotation_degrees = degrees
	
func process_shooting(delta):
	if !is_instance_valid(focus):
		return
	if !armed:
		return
	print("[Tower] " + self.name + " shooting " + focus.name)
	var instance = projectile.instance()
	add_child(instance)
	instance.rotation_degrees = $Sprite.rotation_degrees
	#focus.take_damage(damage)
	armed = false
	$RearmTimer.start()

#reveal the range of the tower
func show_tower_range():
	$Range/CollisionShape2D/Sprite.visible = true
	var timer = Timer.new()
	timer.connect("timeout", self, "toggle_tower_range")
	add_child(timer)
	timer.one_shot = true
	timer.set_wait_time(4)
	timer.start()

#timer event to disable the tower radius sprite
func toggle_tower_range():
	if $Range/CollisionShape2D/Sprite.visible == true:
		$Range/CollisionShape2D/Sprite.visible = false
