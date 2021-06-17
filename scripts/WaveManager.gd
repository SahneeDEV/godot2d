extends Node
class_name WaveManager

# all waves
export(Curve) var waves

# all spawners
var spawners = []
# the current wave
var wave = 0
# the spawners have cleared their wave
var cleared_spawners = []

onready var toasts: ToastManager = get_node("/root/World/GUI/GameInterface/ToastManager")
onready var next_wave_btn: Button = get_node("/root/World/GUI/GameInterface/NextWave")

# emitted when a wave is started
signal wave_started(wave)
# emitted when a wave is cleared
signal wave_cleared(wave)

func _ready():
	next_wave_btn.connect("pressed", self, "_on_next_wave_btn")
	next_wave_btn.visible = true
	spawners = $Spawners.get_children()
	for spawner in spawners:
		spawner.connect("spawning_cleared", self, "_on_spawning_cleared", [spawner])

func _on_spawning_cleared(spawner):
	cleared_spawners.push_back(spawner)
	if cleared_spawners.size() == spawners.size():
		toasts.show_toast("Wave " + str(wave) + " cleared!", Color(0, 1, 0))
		next_wave_btn.visible = true
		emit_signal("wave_cleared", wave)

func next_wave():
	wave += 1
	cleared_spawners.clear()
	toasts.show_toast("Wave " + str(wave) + " started!", Color(0, 1, 1))
	next_wave_btn.visible = false
	emit_signal("wave_started", wave)
	for spawner in spawners:
		spawner.spawn(5)

func _on_next_wave_btn():
	next_wave()
