extends Node
class_name Tower

export var damage = 50
export var draw_target = false

var focus = null
var armed = true

func _ready():
	$Range.connect("body_exited", self, "_on_body_exited")
	$RearmTimer.connect("timeout", self, "_on_rearm")
	set_process(true)

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
	print("Tower " + self.name + " rearmed!")
	armed = true

## Checks if the given body is a valid enemy for this tower.
func is_tower_target(body):
	return body.has_method("is_tower_target") && body.is_tower_target(self)

## Finds a free enemy in the tower range
func find_new_focus():
	for body in $Range.get_overlapping_bodies():
		if is_tower_target(body):
			focus = body
			print("Tower " + self.name + " acquired new target " + focus.name)
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
	print("Tower " + self.name + " shooting " + focus.name)
	focus.take_damage(damage)
	armed = false
	$RearmTimer.start()
