extends GPUParticles3D

@onready var timer := $Timer as Timer

func _ready():
	emitting = true
	timer.timeout.connect(check_end)

func check_end():
	if not emitting:
		queue_free()
