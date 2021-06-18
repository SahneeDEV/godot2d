extends Node

export var game_level = 1
onready var toasts: ToastManager = get_node("/root/World/GUI/GameInterface/ToastManager")

func _ready():
	toasts.show_toast("Welcome to level " + str(game_level) + "!", Color(0.5, 1, 0.2))
