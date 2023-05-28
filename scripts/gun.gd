class_name Gun
extends MeshInstance3D

@export var stats: GunStats
@export var reload_timer: Timer

signal ammo_changed(current: int)
signal reloading(progress: int)

var is_reloading: bool :
	get:
		return not reload_timer.is_stopped()
var reload_progress := 0 :
	set(value):
		reload_progress = clamp(value, 0, 100)

func _ready():
	stats.current_ammo = stats.max_ammo
	reload_timer.timeout.connect(track_reload)

func shoot():
	if stats.current_ammo <= 0 or is_reloading:
		return
	stats.current_ammo -= 1
	ammo_changed.emit(stats.current_ammo)

func reload():
	if reload_timer.is_stopped():
		reload_progress = 0
		reload_timer.start()

func track_reload():
	reload_progress += stats.reload_time / reload_timer.wait_time
	if reload_progress >= 100:
		finish_reload()
		reloading.emit(0)
	else:
		reloading.emit(reload_progress)


func finish_reload():
	reload_timer.stop()
	stats.current_ammo = stats.max_ammo
	ammo_changed.emit(stats.current_ammo)

func stop_reload():
	reload_progress = 0
	reload_timer.stop()
