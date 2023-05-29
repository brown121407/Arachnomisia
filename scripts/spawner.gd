class_name Spawner
extends Marker3D


@export var spider_scene: PackedScene
@export var wait_time := 2.0
@export var max_spawned := 5
@export var spawned := 0 :
	set(value):
		spawned = clamp(value, 0, max_spawned)
@export var progress_every := 5
var killed := 0 :
	set(value):
		if value >= progress_every:
			killed = 0
			max_spawned += 1
		else:
			killed = value

@onready var timer := $Timer as Timer

func _ready():
	timer.wait_time = wait_time
	
func spawn(player: Player):
	if spawned >= max_spawned:
		return
	var spider := spider_scene.instantiate() as Spider
	spider.player = player
	add_child(spider)
	spider.global_position = global_position	
	
	spider.die.connect(func (): 
		spawned -= 1
		killed += 1
	)
	spawned += 1
