extends Label
class_name Toast

func set_toast(t_text, t_color):
	text = t_text
	add_color_override("font_color", t_color)
	# the average reading speed is 200 words per minute, which translates into ~3 words per second
	var time = min(t_text.split(" ").size() / 3, 3)
	$Timer.wait_time = time
	print("[Toast] Showing toast \"" + t_text + "\" in color " + str(t_color) + " for " + str(time) + " seconds")

func _ready():
	$Timer.connect("timeout", self, "_on_timeout")
	
func _on_timeout():
	print("[Toast] Hiding toast")
	queue_free()
