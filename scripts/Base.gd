extends Node
class_name Base

export var hp = 1000 setget _set_hp

onready var stat = preload("res://scenes/Game/Stats/Stat_BaseHealth.tscn")
onready var stats = get_node("/root/World/GUI/GameInterface/Stats")
onready var toasts: ToastManager = get_node("/root/World/GUI/GameInterface/ToastManager")
var stat_instance

var ready = false

signal game_over()

func _ready():
	ready = true
	print("[Base] Created base with " + str(hp) + " HP")
	stat_instance = stat.instance()
	stats.add_child(stat_instance)
	self.hp = hp

func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(self)
		print("[Base] " + body.name + " does damage to " + self.name + " - Health left " + String(hp))

func take_damage(damage):
	self.hp = max(self.hp - damage, 0)
	toasts.show_toast("Your base has taken " + str(floor(damage)) + " damage! (" + (str(hp)) + " Health left)", Color(1, 0, 1))
	if hp == 0:
		emit_signal("game_over")

func _set_hp(new_hp):
	hp = new_hp
	if ready:
		var label = stat_instance.get_node("./Label")
		label.text = str(hp)
