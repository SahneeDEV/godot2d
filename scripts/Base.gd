extends Node
class_name Base

export var hp = 1000 setget _set_hp

onready var stat = preload("res://scenes/Game/Stats/Stat_BaseHealth.tscn")
onready var stats = get_node("/root/World/GUI/GameInterface/Stats")
var stat_instance

func _ready():
	stat_instance = stat.instance()
	stats.add_child(stat_instance)
	self.hp = hp

func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(self)
		print(body.name + " does damage to " + self.name + " --> " + String(hp))

func take_damage(damage):
	self.hp -= damage

func _set_hp(new_hp):
	hp = new_hp
	var label = stat_instance.get_node("./Label")
	label.text = str(hp)
