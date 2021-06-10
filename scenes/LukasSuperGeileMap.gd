extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mob = preload("res://Scenes/mob_lukas.tscn")
onready var tower = preload("res://Scenes/tower_lukas.tscn")
onready var projectile = preload("res://Scenes/projectile_lukas.tscn")

var mobs_remaining = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$mob_spawner.start(1)
	$tower.connect("shoot_projectile", self, "shoot_projectile")
	mobs_remaining = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot_projectile(origin, target):
	var projectile_instance = projectile.instance()
	projectile_instance.original_pos = origin
	projectile_instance.target_pos = target
	$throw.play()
	$entities.add_child(projectile_instance)

func _on_mob_spawner_timeout():
	var mob_uinstance = null
	mob_uinstance = mob.instance()
	
	mob_uinstance.position = $start_pos.position
	mob_uinstance.destination = $end_pos.position

	mob_uinstance.connect("mob_defeated", self, "mob_defeated")
	var path = $path.get_simple_path($start_pos.position, $end_pos.position)
	mob_uinstance.set_path(path)
	mob_uinstance.set_speed(get_next_random_speed())
	
	var next_mob_type = get_next_random_mob()
	#define the mobs
	if next_mob_type < 0.5:
		#weakest mob
		mob_uinstance.set_health(1)
	elif next_mob_type > 0.5:
		#more strong
		mob_uinstance.set_health(2)
	else:
		mob_uinstance.set_health(1)
	
	$entities.add_child(mob_uinstance)
	
	mobs_remaining -= 1
	
	if mobs_remaining > 0:
		$mob_spawner.start(1)

func mob_defeated():
	$death.play()
	pass

# get a random int to give variety to the moving mobs
func get_next_random_speed():
	var rng = RandomNumberGenerator.new()
	rng.randomize();
	return rng.randf_range(100, 600)

func get_next_random_mob():
	var rng = RandomNumberGenerator.new()
	rng.randomize();
	return rng.randf_range(0, 1)
