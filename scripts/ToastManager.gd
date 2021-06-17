extends VBoxContainer
class_name ToastManager

onready var toast = preload("res://scenes/Toast.tscn")

func show_toast(t_text, t_color):
	var instance: Toast = toast.instance()
	instance.set_toast(t_text, t_color)
	add_child(instance)
	return instance
