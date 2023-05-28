extends Gun

@export var ready_to_shoot := true
@onready var shot_timer: Timer = $ShotTimer

func _ready():
	super._ready()
	shot_timer.timeout.connect(func (): ready_to_shoot = true)

func shoot():
	if not ready_to_shoot:
		return
	super.shoot()
	ready_to_shoot = false
	shot_timer.start()
