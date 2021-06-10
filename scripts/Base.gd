extends Node
class_name Base

export var hp = 1000

func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(self)
		print(body.name + " does damage to " + self.name + " --> " + String(hp))

func take_damage(damage):
	hp -= damage
