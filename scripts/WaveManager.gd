extends Node
class_name WaveManager

# the amount of waves
export var wave_count = 10
# the difficulty curve
export(Curve) var difficulty
# the weight a single spawner has, the smaller the harder multiple spawners get
export var spawner_weight = 0.7

# all spawners
var spawners = []
# the current wave
var wave = 0
# the spawners have cleared their wave
var cleared_spawners = []

onready var toasts: ToastManager = get_node("/root/World/GUI/GameInterface/ToastManager")
onready var next_wave_btn: Button = get_node("/root/World/GUI/GameInterface/NextWave")
onready var defeat_ui: Button = get_node("/root/World/GUI/GameInterface/Defeat")
onready var victory_ui: Button = get_node("/root/World/GUI/GameInterface/Victory")
onready var base: Base = get_node("/root/World/Base")

# emitted when a wave is started
signal wave_started(wave)
# emitted when a wave is cleared
signal wave_cleared(wave)
# emitted when the game was won
signal game_won()

func _ready():
	next_wave_btn.connect("pressed", self, "_on_next_wave_btn")
	next_wave_btn.visible = true
	spawners = $Spawners.get_children()
	base.connect("game_over", self, "_on_game_over")
	for spawner in spawners:
		spawner.connect("spawning_cleared", self, "_on_spawning_cleared", [spawner])

func _on_spawning_cleared(spawner):
	cleared_spawners.push_back(spawner)
	if cleared_spawners.size() == spawners.size():
		toasts.show_toast("Wave " + str(wave) + " cleared!", Color(0, 1, 0))
		next_wave_btn.visible = true
		emit_signal("wave_cleared", wave)
		if wave == wave_count:
			emit_signal("game_won")
			game_won()

func next_wave():
	wave += 1
	cleared_spawners.clear()
	var x = float(wave) / float(wave_count)
	var y = difficulty.interpolate(x)
	print("[WaveManager] Next wave " + str(wave) + ", interpolated: (y) " + str(y) + " / (x) " + str(x))
	var amount = 1 + int(y / (spawners.size() * spawner_weight))
	toasts.show_toast("Wave " + str(wave) + " started with " + str(amount) + " enemies", Color(0, 1, 1))
	next_wave_btn.visible = false
	emit_signal("wave_started", wave)
	for spawner in spawners:
		spawner.spawn(amount)

func _on_next_wave_btn():
	next_wave()
	
func _on_game_over():
	defeat_ui.visible = true

func game_won():
	victory_ui.visible = true
